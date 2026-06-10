import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'church_report.g.dart';

@HiveType(typeId: 50)
enum ReportTypeExt {
  @HiveField(0) serviceDivin,           // SD
  @HiveField(1) reunionFreres,          // RF
  @HiveField(2) serviceJeunesse,        // SJ
  @HiveField(3) seminaire,              // S
  @HiveField(4) serviceEcodim,          // SE
  @HiveField(5) serviceFunebre,         // SF
  @HiveField(6) mariage,                // MA
  @HiveField(7) concert,                // C
  @HiveField(8) evangelisation,         
  @HiveField(9) repetition,             
  @HiveField(10) visitePastorale,        
  @HiveField(11) reunionCommission,      
  @HiveField(12) formation,              
  @HiveField(13) activiteSociale,        
  @HiveField(14) autre                   
}

@HiveType(typeId: 51)
enum ReportStatus {
  @HiveField(0) brouillon,
  @HiveField(1) soumis,
  @HiveField(2) valide,
  @HiveField(3) rejete,
  @HiveField(4) archive
}

@HiveType(typeId: 52)
class ChurchReport extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late ReportTypeExt type;
  @HiveField(2) late EntityLevel niveauEntite;
  @HiveField(3) late String nomEntite;           
  @HiveField(4) late String nomChamp;            
  @HiveField(5) late String nomDistrict;         
  @HiveField(6) late DateTime dateRapport;
  @HiveField(7) late DateTime heureDebut;
  @HiveField(8) DateTime? heureFin;
  
  // Contenu liturgique
  @HiveField(9) String cantiqueIntroduction = '';
  @HiveField(10) String texteBiblique = '';
  @HiveField(11) String officiant = '';
  @HiveField(12) List<String> assistants = const [];
  
  // Statistiques
  @HiveField(13) int presenceTotale = 0;
  @HiveField(14) int nombreMembres = 0;
  @HiveField(15) int nombreVisiteurs = 0;
  @HiveField(16) double offrandeFC = 0;
  @HiveField(17) double offrandeDevise = 0;
  @HiveField(18) String numeroRecu = '';
  
  // Actes sacramentels
  @HiveField(19) int nombreBaptemes = 0;
  @HiveField(20) int nombreScelles = 0;
  @HiveField(21) int nombreConfirmations = 0;
  @HiveField(22) int nombreOrdinations = 0;
  @HiveField(23) int nombreMandatements = 0;
  @HiveField(24) int nombreNominations = 0;
  @HiveField(25) int nombreRetraites = 0;
  
  // Workflow
  @HiveField(26) ReportStatus statut = ReportStatus.brouillon;
  @HiveField(27) late String rapporteur;
  @HiveField(28) String? validateur;
  @HiveField(29) DateTime? dateValidation;
  @HiveField(30) String? motifRejet;
  
  // Champs personnalisés
  @HiveField(31) Map<String, String> champsPersonnalises = const {};

  ChurchReport({
    required this.id,
    required this.type,
    required this.niveauEntite,
    required this.nomEntite,
    required this.nomChamp,
    required this.nomDistrict,
    required this.dateRapport,
    required this.heureDebut,
    this.heureFin,
    this.cantiqueIntroduction = '',
    this.texteBiblique = '',
    this.officiant = '',
    this.assistants = const [],
    this.presenceTotale = 0,
    this.nombreMembres = 0,
    this.nombreVisiteurs = 0,
    this.offrandeFC = 0,
    this.offrandeDevise = 0,
    this.numeroRecu = '',
    this.nombreBaptemes = 0,
    this.nombreScelles = 0,
    this.nombreConfirmations = 0,
    this.nombreOrdinations = 0,
    this.nombreMandatements = 0,
    this.nombreNominations = 0,
    this.nombreRetraites = 0,
    this.statut = ReportStatus.brouillon,
    required this.rapporteur,
    this.validateur,
    this.dateValidation,
    this.motifRejet,
    this.champsPersonnalises = const {},
  });
}
