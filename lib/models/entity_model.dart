import 'package:hive/hive.dart';
import 'hierarchy_models.dart';
import 'commission_model.dart';
import 'programme_model.dart';

part 'entity_model.g.dart';

@HiveType(typeId: 233)
class EntityModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String nom;
  @HiveField(2) late String code;
  @HiveField(3) late EntityLevel niveau;

  @HiveField(4) String? entiteParentId;

  @HiveField(5) String? responsableId;
  @HiveField(6) String? responsableNom;
  @HiveField(7) UserRole? responsableRank;

  @HiveField(8) String? suppleantId;
  @HiveField(9) String? suppleantNom;

  @HiveField(10) List<Commission> commissions;

  @HiveField(11) int nombreMembres;
  @HiveField(12) int nombreMinistres;

  @HiveField(13) List<Programme> programmes;

  @HiveField(14) late DateTime createdAt;

  EntityModel({
    required this.id,
    required this.nom,
    required this.code,
    required this.niveau,
    this.entiteParentId,
    this.responsableId,
    this.responsableNom,
    this.responsableRank,
    this.suppleantId,
    this.suppleantNom,
    this.commissions = const [],
    this.nombreMembres = 0,
    this.nombreMinistres = 0,
    this.programmes = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

