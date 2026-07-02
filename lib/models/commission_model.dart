import 'package:hive/hive.dart';
import 'hierarchy_models.dart';
import 'programme_model.dart';
import 'library_document.dart';

part 'commission_model.g.dart';

@HiveType(typeId: 106)
class Commission extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late CommissionType type;
  @HiveField(2) late String entiteId;
  @HiveField(3) String? description;
  @HiveField(4) String? responsableId;
  @HiveField(5) String? responsableNom;
  @HiveField(6) String? adjointId;
  @HiveField(7) String? adjointNom;
  @HiveField(8) List<SousCommission>? sousCommissions;
  @HiveField(9) List<String> membreIds;
  @HiveField(10) List<Programme> programmes;
  @HiveField(11) List<LibraryDocument> manuelsFormateur;
  @HiveField(12) List<LibraryDocument> manuelsApprenant;
  @HiveField(13) late DateTime createdAt;

  Commission({
    required this.id,
    required this.type,
    required this.entiteId,
    this.description,
    this.responsableId,
    this.responsableNom,
    this.adjointId,
    this.adjointNom,
    this.sousCommissions,
    this.membreIds = const [],
    this.programmes = const [],
    this.manuelsFormateur = const [],
    this.manuelsApprenant = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

@HiveType(typeId: 107)
class SousCommission extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String nom;
  @HiveField(2) String? responsableId;

  SousCommission({
    required this.id,
    required this.nom,
    this.responsableId,
  });
}


