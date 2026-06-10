enum ReportType {
  sacristie, serviceDivin, saintsScelles, funeraille,
  communique, presenceReunion, feuilleRoute, visitePastorale,
  ecodim, confirmation, jeunesse, econfi, medicale,
  aines, construction, securite, presse, papas, mamans,
  arimathee, musique
}

enum ValidationStatus {
  brouillon, soumis, valideCommunaute, valideDouble, rejete, archive
}

class KPI {
  final String nom;
  final double valeur;
  final double objectif;
  final String unite;
  final DateTime periode;
  
  KPI({
    required this.nom,
    required this.valeur,
    required this.objectif,
    required this.unite,
    required this.periode,
  });
  
  double get tauxRealisation => (valeur / objectif) * 100;
  bool get objectifAtteint => tauxRealisation >= 100;
}

class Report {
  final String id;
  final ReportType type;
  final String entiteId;
  final Map<String, dynamic> data;
  final ValidationStatus status;
  final DateTime dateCreation;
  final DateTime? dateValidationCommunaute;
  final DateTime? dateValidationHierarchique;
  final String? commentaireValidation;
  final List<KPI> kpis;
  final List<String> temoins;
  final String? pdfUrl;
  
  Report({
    required this.id,
    required this.type,
    required this.entiteId,
    required this.data,
    this.status = ValidationStatus.brouillon,
    required this.dateCreation,
    this.dateValidationCommunaute,
    this.dateValidationHierarchique,
    this.commentaireValidation,
    this.kpis = const [],
    this.temoins = const [],
    this.pdfUrl,
  });
  
  bool get isValideDouble => 
    status == ValidationStatus.valideDouble ||
    (dateValidationCommunaute != null && dateValidationHierarchique != null);
}
