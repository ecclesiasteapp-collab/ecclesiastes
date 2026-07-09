import 'package:flutter/foundation.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/services/database_service.dart';
import 'package:ecclesiaste/utils/password_utils.dart';
import 'package:ecclesiaste/utils/secure_storage_helper.dart';
import 'package:ecclesiaste/services/logging_service.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ecclesiaste/providers/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/hierarchy_models.dart';
import '../config/app_config.dart';

class AuthService {
  /// Session typée au lieu d'une Map pour la robustesse (Production ready)
  static User? currentUser;

  static String? filterCommunauteId;
  final Box<User> _userBox = Hive.box<User>(DatabaseService.usersBoxName);
  final _secureStorage = const FlutterSecureStorage();

  // Ajoutez cette ligne
  static ProviderContainer? _container;

  // Utilisation de la configuration centralisée
  static const String defaultAdminEmail = AppConfig.adminEmail;
  static const String defaultAdminPassword = AppConfig.adminPassword;

  static String get currentUserId => currentUser?.id ?? '';
  static String get currentEntiteId => currentUser?.entityId ?? '';

  static bool isSuperAdmin() => currentUser?.role == UserRole.superAdmin;

  /// Vérifie si l'utilisateur a des droits de gestion (RBAC)
  static bool isResponsable() {
    if (currentUser == null) return false;
    if (isSuperAdmin()) return true;

    // Tous les ministres (du Diacre à l'Apôtre Patriarche) et responsables de commission
    // sont considérés comme "Responsables" dans le système.
    return currentUser!.role != UserRole.membre;
  }

  static bool isMinistre() {
    if (currentUser == null) return false;
    return currentUser!.role != UserRole.membre && currentUser!.role != UserRole.superAdmin;
  }

  // Dans la classe AuthService
  static void setProviderContainer(ProviderContainer container) {
    _container = container;
  }

  /// Initialisation : Crée le Super Admin si absent
  Future<void> initializeDefaultAdmin() async {
    const adminId = 'admin_root_001';
    if (_userBox.get(adminId) == null) {
      final superAdmin = User(
        id: adminId,
        fullName: 'Nestor Mbuyi Kankolongo',
        email: defaultAdminEmail,
        passwordHash: User.hashPassword(defaultAdminPassword),
        role: UserRole.superAdmin,
        entityLevel: EntityLevel.internationale,
        entityId: 'ROOT',
        isActive: true,
        status: 'active',
      );
      await _userBox.put(superAdmin.id, superAdmin);
      debugPrint('✅ Super Admin initialisé.');
    }
  }

  static Future<bool> login({
    required String identifiant,
    required String password,
  }) async {
    final auth = AuthService();
    // Assurez-vous que le container est défini avant d'appeler login
    if (_container == null) {
      debugPrint('Erreur: ProviderContainer non défini dans AuthService. Veuillez appeler setProviderContainer.');
      // Gérer l'erreur ou initialiser le container si possible
      return false;
    }
    final hashedPwd = User.hashPassword(password);
    
    // 1. Recherche dans Hive (Source prioritaire pour les administrateurs et accès locaux)
    User? userFound = auth._userBox.values.where(
      (u) => u.email.toLowerCase() == identifiant.toLowerCase() && u.passwordHash == hashedPwd && u.status == 'active'
    ).firstOrNull;

    // 2. Recherche dans SQLite (Fallback pour les utilisateurs importés en masse)
    if (userFound == null) {
      final sqliteUser = await DatabaseHelper.instance.getUtilisateurByIdentifiant(identifiant);
      if (sqliteUser != null && verifyPassword(password, sqliteUser['mot_de_passe'])) {
        // Conversion Map SQLite -> Objet User
        userFound = User(
          id: sqliteUser['id'].toString(),
          fullName: sqliteUser['nom_complet'] ?? 'Utilisateur Inconnu',
          email: sqliteUser['identifiant'] ?? identifiant,
          passwordHash: sqliteUser['mot_de_passe'],
          role: _mapStringToRole(sqliteUser['role']),
          entityId: sqliteUser['entite_id'] ?? 'COMMUNE',
          entityLevel: _mapStringToLevel(sqliteUser['niveau_entite']),
          status: 'active',
        );
      }
    }

    if (userFound != null) {
      currentUser = userFound;
      currentUser!.lastLogin = DateTime.now();
      await currentUser!.save();

      // Persistance de la session
      await SecureStorageHelper.saveSession({
        'user_id': userFound.id,
        'email': userFound.email,
        'role': userFound.role.name,
      });
      
      await auth._secureStorage.write(key: 'session_user_id', value: userFound.id);
      LoggingService.logAuth('login', userId: userFound.id, message: 'User ${userFound.fullName} logged in');

      // Notifier le AuthStateNotifier
      _container?.read(authStateProvider.notifier).login();
      return true;
    }

    return false;
  }

  // Ajoutez cette nouvelle méthode dans la classe AuthService
  static Future<void> restoreSession() async {
    final hasSession = await SecureStorageHelper.hasSession();
    if (hasSession) {
      final sessionData = await SecureStorageHelper.getSession();
      if (sessionData != null) {
        final userId = sessionData['user_id'];
        if (userId != null) {
          final userFromDb = await DatabaseHelper.instance.getUserById(userId);
          if (userFromDb != null) {
            // On ne peut pas assigner une Map à un User, il faut le reconstruire.
                        currentUser = User.fromMap(userFromDb); // Reconstruire l'objet User à partir de la Map
            // currentUser = User.fromMap(userFromDb);
          }
          // Si l'utilisateur n'a pas été trouvé via DatabaseHelper (legacy), essayer Hive
          currentUser ??= Hive.box<User>(DatabaseService.usersBoxName).get(userId);
        }
      }
    }
  }

  static UserRole _mapStringToRole(String? roleStr) {
    if (roleStr == null) return UserRole.membre;
    return UserRole.values.firstWhere(
      (e) => e.name.toUpperCase() == roleStr.toUpperCase(),
      orElse: () => UserRole.membre,
    );
  }

  static EntityLevel _mapStringToLevel(String? levelStr) {
    if (levelStr == null) return EntityLevel.communaute;
    return EntityLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == levelStr.toLowerCase(),
      orElse: () => EntityLevel.communaute,
    );
  }

  Future<User?> getCurrentUser() async {
    final userId = await _secureStorage.read(key: 'session_user_id');
    if (userId == null) return null;
    return _userBox.get(userId);
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
    required EntityLevel entityLevel,
    required String entityId,
    String? entityRole,
    CommissionType? commissionType,
    CommissionRole? commissionRole,
    String? photoPath,
  }) async {
    if (_userBox.values.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return false;
    }

    final newUser = User(
      id: 'USR_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email.toLowerCase(),
      passwordHash: User.hashPassword(password),
      role: role,
      entityLevel: entityLevel,
      entityId: entityId,
      entityRole: entityRole,
      commissionType: commissionType,
      commissionRole: commissionRole,
      photoPath: photoPath,
      isActive: role == UserRole.membre,
      status: 'active', // Par défaut pour register direct (admin)
    );


    await _userBox.put(newUser.id, newUser);
    return true;
  }

  // --- LOGIQUE D'INSCRIPTION LIBRE ET VALIDATION (NE PAS MODIFIER SANS ACCORD) ---

  /// Inscrire un utilisateur en attente de validation
  static Future<void> registerPendingUser(User user) async {
    final box = await DatabaseService.openBox<User>(DatabaseService.pendingUsersBoxName);
    await box.put(user.id, user);

    // Envoyer une notification au responsable de l'entité
    await _notifyEntityResponsible(user);
  }

  static Future<void> _notifyEntityResponsible(User user) async {
    // Logique de notification (Simulation)
    debugPrint('📢 Notification envoyée au responsable de ${user.entityId}');
    debugPrint('Nouvelle inscription en attente: ${user.fullName} (${user.email})');
  }

  /// Valider un utilisateur (à appeler par le responsable)
  static Future<void> validateUser(String userId) async {
    final pendingBox = await DatabaseService.openBox<User>(DatabaseService.pendingUsersBoxName);
    final usersBox = Hive.box<User>(DatabaseService.usersBoxName);

    final pendingUser = pendingBox.get(userId);
    if (pendingUser != null) {
      // Mettre à jour l'objet pour activation
      pendingUser.status = 'active';
      pendingUser.isActive = true;
      pendingUser.validatedAt = DateTime.now();

      // Ajouter aux utilisateurs actifs et supprimer de la liste d'attente
      await usersBox.put(pendingUser.id, pendingUser);
      await pendingBox.delete(userId);

      // Confirmation
      debugPrint('✅ Email de confirmation envoyé à ${pendingUser.email}');
    }
  }
  // -----------------------------------------------------------------------------

  Future<bool> resetPassword(String identifiant, String newPassword) async {
    final user = _userBox.values.where(
      (u) => u.email.toLowerCase() == identifiant.toLowerCase() || u.id == identifiant
    ).firstOrNull;

    if (user != null) {
      user.passwordHash = User.hashPassword(newPassword);
      await user.save();
      return true;
    }

    try {
      final sqliteUser = await DatabaseHelper.instance.getUtilisateurByIdentifiant(identifiant);
      if (sqliteUser != null) {
        await DatabaseHelper.instance.mettreAJourMotDePasse(sqliteUser['id'].toString(), User.hashPassword(newPassword));
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    currentUser = null;
    filterCommunauteId = null;
    await SecureStorageHelper.clearSession();
    await const FlutterSecureStorage().deleteAll();

    // Notifier le AuthStateNotifier
    _container?.read(authStateProvider.notifier).logout(); // <--- AJOUTEZ CETTE LIGNE
  }
}

