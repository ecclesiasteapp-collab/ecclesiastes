import 'package:hive/hive.dart';
import '../domain/repositories/user_repository.dart';
import '../models/user.dart';
import 'database_service.dart';

class HiveUserRepository implements UserRepository {
  @override
  Future<List<User>> getAllUsers() async {
    final box = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    return box.values.toList();
  }

  @override
  Future<List<User>> getPendingUsers() async {
    final box = await DatabaseService.openBox<User>(DatabaseService.pendingUsersBoxName);
    return box.values.toList();
  }

  @override
  Future<User?> getUserById(String id) async {
    final box = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    return box.get(id);
  }

  @override
  Future<void> saveUser(User user) async {
    final box = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    await box.put(user.id, user);
  }

  @override
  Future<void> validateUser(String userId) async {
    final pendingBox = await DatabaseService.openBox<User>(DatabaseService.pendingUsersBoxName);
    final usersBox = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    
    final user = pendingBox.get(userId);
    if (user != null) {
      await usersBox.put(userId, user);
      await pendingBox.delete(userId);
    }
  }

  @override
  Future<void> rejectUser(String userId) async {
    final pendingBox = await DatabaseService.openBox<User>(DatabaseService.pendingUsersBoxName);
    await pendingBox.delete(userId);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final usersBox = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    await usersBox.delete(userId);
  }

  @override
  Future<void> updateUserRole(String userId, UserRole role) async {
    final usersBox = await DatabaseService.openBox<User>(DatabaseService.usersBoxName);
    final user = usersBox.get(userId);
    if (user != null) {
      user.role = role;
      await usersBox.put(userId, user);
    }
  }
}
