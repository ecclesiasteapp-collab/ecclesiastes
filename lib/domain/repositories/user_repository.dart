import '../../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<List<User>> getPendingUsers();
  Future<User?> getUserById(String id);
  Future<void> saveUser(User user);
  Future<void> validateUser(String userId);
  Future<void> rejectUser(String userId);
  Future<void> deleteUser(String userId);
  Future<void> updateUserRole(String userId, UserRole role);
}
