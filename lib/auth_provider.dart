import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/user.dart';
import 'models/hierarchy_models.dart';
import 'services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Vérifier si l'utilisateur était connecté
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await _secureStorage.read(key: 'session_user_id');
      if (userId != null) {
        final user = await DatabaseService.getUser(userId);
        if (user != null && user.isActive) {
          _currentUser = user;
          _errorMessage = null;
        } else {
          await logout();
        }
      }
    } catch (e) {
      _errorMessage = 'Erreur de vérification: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Connexion utilisateur
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final users = DatabaseService.getAllUsers();
      final user = users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Utilisateur non trouvé'),
      );

      if (!user.isActive) {
        throw Exception('Compte désactivé');
      }

      // Note: In a real app, verify password here
      _currentUser = user;
      await _secureStorage.write(key: 'session_user_id', value: user.id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erreur de connexion: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _currentUser = null;
    await _secureStorage.delete(key: 'session_user_id');
    notifyListeners();
  }

  /// Vérifier les permissions par rôle
  bool hasRole(UserRole requiredRole) {
    if (_currentUser == null) return false;
    // Plus l'index est bas, plus le rôle est élevé (0: apotrePatriarche, 14: membre)
    return _currentUser!.role.index <= requiredRole.index;
  }

  /// Vérifier l'accès par entité
  bool canAccessEntity(EntityLevel entityLevel, String entityId) {
    if (_currentUser == null) return false;
    if (_currentUser!.role == UserRole.superAdmin) return true;

    // Logique simplifiée
    if (_currentUser!.entityId == entityId) return true;

    // On pourrait ajouter une logique de vérification de parenté ici
    return false;
  }
}

