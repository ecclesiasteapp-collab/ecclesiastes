import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'hierarchy_models.dart';

part 'user.g.dart';

@HiveType(typeId: 101)
class User extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String fullName;
  @HiveField(2) late String email;
  @HiveField(3) late String passwordHash;
  @HiveField(4) late UserRole role;
  @HiveField(5) String? entityId;
  @HiveField(6) String? commissionType; 
  @HiveField(7) bool isActive;
  @HiveField(8) late DateTime createdAt;
  @HiveField(9) DateTime? lastLogin;
  @HiveField(10) String? entityLevel;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.entityId,
    this.commissionType,
    this.isActive = true,
    this.entityLevel,
    DateTime? createdAt,
    this.lastLogin,
  }) : createdAt = createdAt ?? DateTime.now();

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool get isSuperAdmin => role == UserRole.superAdmin;
}
