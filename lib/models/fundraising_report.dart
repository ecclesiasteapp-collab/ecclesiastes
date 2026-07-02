import 'package:hive/hive.dart';

part 'fundraising_report.g.dart';

@HiveType(typeId: 53)
class FundraisingReport extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String entityLevel; // Communauté, District, Champ
  @HiveField(2) late String entityName;
  @HiveField(3) late String districtName;
  @HiveField(4) late String champName;
  
  @HiveField(5) late String motif; // Ex: Construction, Jeunesse, Econfi
  @HiveField(6) late String commissionOrganisatrice;
  @HiveField(7) late DateTime dateCollecte;
  
  // Montants en FC
  @HiveField(8) double cotisationsFC = 0;
  @HiveField(9) double collecteSpecialeFC = 0;
  @HiveField(10) double donsDiversFC = 0;
  @HiveField(11) double autresFC = 0;
  
  // Montants en Devise
  @HiveField(12) double cotisationsDevise = 0;
  @HiveField(13) double collecteSpecialeDevise = 0;
  @HiveField(14) double donsDiversDevise = 0;
  @HiveField(15) double autresDevise = 0;
  
  @HiveField(16) int nombreContributeurs = 0;
  @HiveField(17) int nombreAbsentsCotisants = 0;
  
  @HiveField(18) late String destinationFonds; // Projet local, District, Champ, Autre
  @HiveField(19) String precisionDestination = '';
  @HiveField(20) String observations = '';
  
  @HiveField(21) late String rapporteur;
  @HiveField(22) String approuvePar = '';
  @HiveField(23) late DateTime dateSoumission;

  FundraisingReport({
    required this.id,
    required this.entityLevel,
    required this.entityName,
    required this.districtName,
    required this.champName,
    required this.motif,
    required this.commissionOrganisatrice,
    required this.dateCollecte,
    this.cotisationsFC = 0,
    this.collecteSpecialeFC = 0,
    this.donsDiversFC = 0,
    this.autresFC = 0,
    this.cotisationsDevise = 0,
    this.collecteSpecialeDevise = 0,
    this.donsDiversDevise = 0,
    this.autresDevise = 0,
    this.nombreContributeurs = 0,
    this.nombreAbsentsCotisants = 0,
    required this.destinationFonds,
    this.precisionDestination = '',
    this.observations = '',
    required this.rapporteur,
    this.approuvePar = '',
    required this.dateSoumission,
  });

  double get totalFC => cotisationsFC + collecteSpecialeFC + donsDiversFC + autresFC;
  double get totalDevise => cotisationsDevise + collecteSpecialeDevise + donsDiversDevise + autresDevise;
}

