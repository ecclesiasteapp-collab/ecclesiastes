import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'programme_model.g.dart';

@HiveType(typeId: 110)
class Programme extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String responsableId;
  @HiveField(2) late String responsableType;    // 'ministere' ou 'commission'
  @HiveField(3) late String entiteId;

  @HiveField(4) late ProgrammeType type;
  @HiveField(5) late String titre;
  @HiveField(6) String? description;
  @HiveField(7) List<Activite> activites;

  @HiveField(8) late DateTime dateDebut;
  @HiveField(9) late DateTime dateFin;

  @HiveField(10) late StatutProgramme statut;

  Programme({
    required this.id,
    required this.responsableId,
    required this.responsableType,
    required this.entiteId,
    required this.type,
    required this.titre,
    this.description,
    this.activites = const [],
    required this.dateDebut,
    required this.dateFin,
    this.statut = StatutProgramme.brouillon,
  });
}

@HiveType(typeId: 111)
class Activite extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titre;
  @HiveField(2) late DateTime date;
  @HiveField(3) String? lieu;
  @HiveField(4) String? description;
  @HiveField(5) List<String> responsablesIds;
  @HiveField(6) bool estAnnonce;

  Activite({
    required this.id,
    required this.titre,
    required this.date,
    this.lieu,
    this.description,
    this.responsablesIds = const [],
    this.estAnnonce = false,
  });
}

