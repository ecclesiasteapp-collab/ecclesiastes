import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'church_report.g.dart';

@HiveType(typeId: 50)
enum ReportTypeExt {
  // CATÉGORIE 1 : RAPPORTS MINISTÉRIELS
  @HiveField(0) serviceDivin,
  @HiveField(1) visitePastorale,
  @HiveField(2) communionFraternelle,
  @HiveField(3) ordinationInstallation,
  @HiveField(4) funerailles,
  @HiveField(5) mariage,
  @HiveField(6) bapteme,
  @HiveField(7) sainteCene,
  @HiveField(8) sacristie,
  @HiveField(33) scellement,

  // CATÉGORIE 2 : RAPPORTS DES COMMISSIONS
  @HiveField(9) ecodim,
  @HiveField(10) econfi,
  @HiveField(11) jeunesse,
  @HiveField(12) papas,
  @HiveField(13) mamans,
  @HiveField(14) aines,
  @HiveField(15) musiqueTechnique,
  @HiveField(16) musiqueOrchestre,
  @HiveField(17) presseMedias,
  @HiveField(18) josephArimathee,
  @HiveField(19) securiteProtocole,
  @HiveField(20) medicale,
  @HiveField(21) construction,

  // CATÉGORIE 3 : RAPPORTS DE CONSOLIDATION
  @HiveField(22) consolidationCommunaute,
  @HiveField(23) consolidationDistrict,
  @HiveField(24) consolidationChamp,
  @HiveField(25) consolidationTerritorial,
  @HiveField(26) consolidationInternational,

  // CATÉGORIE 4 : RAPPORTS SPÉCIAUX
  @HiveField(27) collecteFundraising,
  @HiveField(28) evenementSpecial,
  @HiveField(29) mensuelActivite,
  @HiveField(30) trimestrielActivite,
  @HiveField(31) annuelActivite,

  @HiveField(32) autre,
  @HiveField(34) reunionCommission,
  @HiveField(35) seminaire,
  @HiveField(36) repetition,
  @HiveField(37) formation,
  @HiveField(38) activiteSociale,
  @HiveField(39) inventaire,
  @HiveField(40) gestionDistrict,
  @HiveField(41) gestionCommunaute,
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
  @HiveField(38) String nomRegion = ''; // Conforme au DCG Juillet 2026 (6 niveaux)
         
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
  @HiveField(36) String? rapporteurId;
  @HiveField(28) String? validateur;

  @HiveField(29) DateTime? dateValidation;
  @HiveField(30) String? motifRejet;
  
  // Champs personnalisés
  @HiveField(31) Map<String, String> champsPersonnalises = const {};

  // --- SIGNATURE NUMÉRIQUE (Production Ready) ---
  @HiveField(35) String? signaturePath;
  @HiveField(37) String? signatureBase64; 

  // --- VERSIONING & CONFLITS (Production Ready) ---
  @HiveField(32) int version = 1;
  @HiveField(33) DateTime? updatedAt;
  @HiveField(34) String? lastModifiedBy;

  ChurchReport({
    required this.id,
    required this.type,
    required this.niveauEntite,
    required this.nomEntite,
    required this.nomChamp,
    required this.nomDistrict,
    this.nomRegion = '',
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
    this.rapporteurId,
    this.validateur,
    this.dateValidation,
    this.motifRejet,
    this.champsPersonnalises = const {},
    this.signaturePath,
    this.signatureBase64,
    this.version = 1,
    this.updatedAt,
    this.lastModifiedBy,
  });

  /// Incrémente la version lors d'une modification
  void markAsUpdated(String userId) {
    version++;
    updatedAt = DateTime.now();
    lastModifiedBy = userId;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'niveauEntite': niveauEntite.index,
      'nomEntite': nomEntite,
      'nomChamp': nomChamp,
      'nomDistrict': nomDistrict,
      'nomRegion': nomRegion,
      'dateRapport': dateRapport.toIso8601String(),
      'heureDebut': heureDebut.toIso8601String(),
      'heureFin': heureFin?.toIso8601String(),
      'cantiqueIntroduction': cantiqueIntroduction,
      'texteBiblique': texteBiblique,
      'officiant': officiant,
      'assistants': assistants,
      'presenceTotale': presenceTotale,
      'nombreMembres': nombreMembres,
      'nombreVisiteurs': nombreVisiteurs,
      'offrandeFC': offrandeFC,
      'offrandeDevise': offrandeDevise,
      'numeroRecu': numeroRecu,
      'nombreBaptemes': nombreBaptemes,
      'nombreScelles': nombreScelles,
      'nombreConfirmations': nombreConfirmations,
      'nombreOrdinations': nombreOrdinations,
      'nombreMandatements': nombreMandatements,
      'nombreNominations': nombreNominations,
      'nombreRetraites': nombreRetraites,
      'statut': statut.index,
      'rapporteur': rapporteur,
      'rapporteurId': rapporteurId,
      'validateur': validateur,
      'dateValidation': dateValidation?.toIso8601String(),
      'motifRejet': motifRejet,
      'champsPersonnalises': champsPersonnalises,
      'signaturePath': signaturePath,
      'signatureBase64': signatureBase64,
      'version': version,
      'updatedAt': updatedAt?.toIso8601String(),
      'lastModifiedBy': lastModifiedBy,
    };
  }

  factory ChurchReport.fromMap(Map<String, dynamic> map) {
    return ChurchReport(
      id: map['id'],
      type: ReportTypeExt.values[map['type']],
      niveauEntite: EntityLevel.values[map['niveauEntite']],
      nomEntite: map['nomEntite'],
      nomChamp: map['nomChamp'],
      nomDistrict: map['nomDistrict'],
      nomRegion: map['nomRegion'] ?? '',
      dateRapport: DateTime.parse(map['dateRapport']),
      heureDebut: DateTime.parse(map['heureDebut']),
      heureFin: map['heureFin'] != null ? DateTime.parse(map['heureFin']) : null,
      cantiqueIntroduction: map['cantiqueIntroduction'],
      texteBiblique: map['texteBiblique'],
      officiant: map['officiant'],
      assistants: List<String>.from(map['assistants']),
      presenceTotale: map['presenceTotale'],
      nombreMembres: map['nombreMembres'],
      nombreVisiteurs: map['nombreVisiteurs'],
      offrandeFC: map['offrandeFC'],
      offrandeDevise: map['offrandeDevise'],
      numeroRecu: map['numeroRecu'],
      nombreBaptemes: map['nombreBaptemes'],
      nombreScelles: map['nombreScelles'],
      nombreConfirmations: map['nombreConfirmations'],
      nombreOrdinations: map['nombreOrdinations'],
      nombreMandatements: map['nombreMandatements'],
      nombreNominations: map['nombreNominations'],
      nombreRetraites: map['nombreRetraites'],
      statut: ReportStatus.values[map['statut']],
      rapporteur: map['rapporteur'],
      rapporteurId: map['rapporteurId'],
      validateur: map['validateur'],
      dateValidation: map['dateValidation'] != null ? DateTime.parse(map['dateValidation']) : null,
      motifRejet: map['motifRejet'],
      champsPersonnalises: Map<String, String>.from(map['champsPersonnalises']),
      signaturePath: map['signaturePath'],
      signatureBase64: map['signatureBase64'],
      version: map['version'],
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      lastModifiedBy: map['lastModifiedBy'],
    );
  }
}
