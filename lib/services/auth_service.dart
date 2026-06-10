import 'package:flutter/foundation.dart';
import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/utils/password_utils.dart';
import 'package:ecclesiastes/utils/secure_storage_helper.dart';
import 'package:ecclesiastes/services/logging_service.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../models/hierarchy_models.dart';

class AuthService {
  static Map<String, dynamic>? currentUser;
  static String? filterCommunauteId;
  final Box<User> _userBox = Hive.box<User>('users');
  final _secureStorage = const FlutterSecureStorage();

  // 🔑 Identifiants du Super Administrateur
  static const String defaultAdminEmail = 'superadmin@ecclesiastes.rdc';
  static const String defaultAdminPassword = 'Admin@2026!RDC';

  static String get currentEntiteId => currentUser?['entite_id']?.toString() ?? '';

  static bool isSuperAdmin() {
    final role = currentUser?['role'];
    return role == 'SUPER_ADMIN' || role == UserRole.superAdmin || role == UserRole.superAdmin.name;
  }

  static bool isResponsable() {
    final label = currentUser?['role_label']?.toString() ?? '';
    return isSuperAdmin() || label.contains('Responsable') || label == 'Apôtre' || label == 'Ministre';
  }

  /// Initialisation : Crée Nestor Mbuyi Kankolongo comme Super Admin
  Future<void> initializeDefaultAdmin() async {
    const adminId = 'admin_root_001';
    if (_userBox.get(adminId) == null) {
      final superAdmin = User(
        id: adminId,
        fullName: 'Nestor Mbuyi Kankolongo',
        email: defaultAdminEmail,
        passwordHash: User.hashPassword(defaultAdminPassword),
        role: UserRole.superAdmin,
        entityLevel: 'INTERNATIONALE',
        entityId: 'ROOT',
        isActive: true,
      );
      await _userBox.put(superAdmin.id, superAdmin);
      debugPrint('✅ Super Admin Nestor Mbuyi créé avec succès.');
    }
  }

  static Future<bool> login({
    required String identifiant,
    required String password,
    required String communauteId,
    String? ministere,
    String? roleLabel,
  }) async {
    final auth = AuthService();
    final hashedPwd = User.hashPassword(password);
    
    // 1. Vérification dans Hive (Super Admin)
    final hiveUser = auth._userBox.values.where(
      (u) => u.email.toLowerCase() == identifiant.toLowerCase() && u.passwordHash == hashedPwd
    ).firstOrNull;

    if (hiveUser != null) {
      currentUser = {
        'id': hiveUser.id,
        'user_id': hiveUser.id,
        'nom_complet': hiveUser.fullName,
        'identifiant_email': hiveUser.email,
        'role': 'SUPER_ADMIN',
        'role_label': 'Super Administrateur',
        'entite_id': hiveUser.entityId ?? 'ROOT',
        'communaute_id': hiveUser.entityId ?? 'ROOT',
      };
      await SecureStorageHelper.saveSession(currentUser!);
      await auth._secureStorage.write(key: 'session_user_id', value: hiveUser.id);
      LoggingService.logAuth('login', userId: currentUser!['id'], message: 'Super Admin Nestor Mbuyi logged in');
      return true;
    }

    // 2. Vérification dans SQLite (Utilisateurs standards)
    final user = await DatabaseHelper.instance.getUtilisateurByIdentifiant(identifiant);
    if (user == null) return false;

    if (verifyPassword(password, user['mot_de_passe_hash'])) {
      currentUser = Map<String, dynamic>.from(user);
      currentUser!['id'] ??= user['id'];
      if (ministere != null) currentUser!['ministere'] = ministere;
      if (roleLabel != null) currentUser!['role_label'] = roleLabel;
      
      await SecureStorageHelper.saveSession(currentUser!);
      await auth._secureStorage.write(key: 'session_user_id', value: currentUser!['id'].toString());
      LoggingService.logAuth('login', userId: currentUser!['id']?.toString(), message: 'User logged in via SQLite');
      return true;
    }
    return false;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final user = _userBox.values.where(
      (u) => u.email.toLowerCase() == email.toLowerCase()
    ).firstOrNull;

    if (user != null) {
      user.passwordHash = User.hashPassword(newPassword);
      await user.save();
      return true;
    }
    
    // Si pas dans Hive, on tente SQLite
    try {
      await DatabaseHelper.instance.mettreAJourMotDePasse(email, hashPassword(newPassword));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    final userId = await _secureStorage.read(key: 'session_user_id');
    if (userId == null) return null;
    return _userBox.get(userId);
  }

  static Future<void> logout() async {
    currentUser = null;
    filterCommunauteId = null;
    await SecureStorageHelper.clearSession();
    await const FlutterSecureStorage().deleteAll();
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
    required String entityLevel,
    required String entityId,
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
      isActive: role == UserRole.membre,
    );

    await _userBox.put(newUser.id, newUser);
    return true;
  }
}
