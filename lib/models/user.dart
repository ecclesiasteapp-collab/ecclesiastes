import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'hierarchy_models.dart';
import '../core/rbac/admin_roles.dart';

part 'user.g.dart';

@HiveType(typeId: 101)
class User extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String fullName;
  @HiveField(2) late String email;
  @HiveField(3) late String passwordHash;
  @HiveField(4) late UserRole role;
  @HiveField(5) String? entityId;
  @HiveField(6) CommissionType? commissionType;
  @HiveField(7) bool isActive;
  @HiveField(8) late DateTime createdAt;
  @HiveField(9) DateTime? lastLogin;
  @HiveField(10) EntityLevel? entityLevel;
  @HiveField(11) String? phone;
  @HiveField(12) CommissionRole? commissionRole;
  @HiveField(13) ProfilDocumentaire? profil;
  @HiveField(14) String? entityRole; // "responsable", "suppleant" or null
  @HiveField(15) String? photoPath;
  @HiveField(16) String status; // 'active', 'pending', 'rejected'
  @HiveField(17) DateTime? pendingSince;
  @HiveField(18) DateTime? validatedAt;

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
    this.phone,
    this.commissionRole,
    this.profil,
    this.entityRole,
    this.photoPath,
    this.status = 'active',
    this.pendingSince,
    this.validatedAt,
    DateTime? createdAt,
    this.lastLogin,
  }) : createdAt = createdAt ?? DateTime.now();


  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Compatibilité avec l'ancien code Map
  dynamic operator [](String key) {
    switch (key) {
      case 'id': return id;
      case 'user_id': return id;
      case 'nom_complet': return fullName;
      case 'identifiant_email': return email;
      case 'role': return role.name;
      case 'entite_id': return entityId;
      case 'communaute_id': return entityId;
      case 'niveau_entite': return entityLevel?.name;
      case 'role_label': return role.name;
      case 'nom_champ': return 'Ecclésiaste';
      case 'nom_district': return 'District';

      case 'nom_communaute': return 'Communauté';
      default: return null;
    }
  }

  bool get isSuperAdmin => role == UserRole.superAdmin;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"]?.toString() ?? "".toString(),
      fullName: map["nom_complet"] as String? ?? "",
      email: map["identifiant_email"] as String? ?? "",
      passwordHash: map["mot_de_passe"] as String? ?? "",
      role: UserRole.values.firstWhere(
        (e) => e.name.toLowerCase() == (map["role"] as String? ?? "").toLowerCase(),
        orElse: () => UserRole.membre,
      ),
      entityId: map["entite_id"] as String?,
      entityLevel: EntityLevel.values.firstWhere(
        (e) => e.name.toLowerCase() == (map["niveau_entite"] as String? ?? "").toLowerCase(),
        orElse: () => EntityLevel.communaute,
      ),
      isActive: (map["isActive"] as bool?) ?? true,
      status: map["status"] as String? ?? "active",
      createdAt: map["createdAt"] != null ? DateTime.parse(map["createdAt"] as String) : DateTime.now(),
      lastLogin: map["lastLogin"] != null ? DateTime.parse(map["lastLogin"] as String) : null,
      phone: map["phone"] as String?,
      commissionType: map["commissionType"] != null
          ? CommissionType.values.firstWhere(
              (e) => e.name.toLowerCase() == (map["commissionType"] as String).toLowerCase(),
              orElse: () => CommissionType.none,
            )
          : null,
      commissionRole: map["commissionRole"] != null
          ? CommissionRole.values.firstWhere(
              (e) => e.name.toLowerCase() == (map["commissionRole"] as String).toLowerCase(),
              orElse: () => CommissionRole.membre,
            )
          : null,
      profil: map["profil"] != null
          ? ProfilDocumentaire.values.firstWhere(
              (e) => e.name.toLowerCase() == (map["profil"] as String).toLowerCase(),
              orElse: () => ProfilDocumentaire.membre,
            )
          : null,
      entityRole: map["entityRole"] as String?,
      photoPath: map["photoPath"] as String?,
    );
  }

  /// Niveau d'administration (RBAC) dérivé du rôle et du niveau d'entité.
  AdminLevel get adminLevel {
    if (isSuperAdmin) return AdminLevel.superAdmin;

    switch (entityLevel) {
      case EntityLevel.communaute:
        return AdminLevel.community;
      case EntityLevel.district:
        return AdminLevel.district;
      case EntityLevel.champ:
        return AdminLevel.champ;
      case EntityLevel.territoriale:
        return AdminLevel.territorial;
      case EntityLevel.internationale:
        return AdminLevel.superAdmin;
      default:
        return AdminLevel.community;
    }
  }

  List<String>? get delegatedPermissions => null;
}


