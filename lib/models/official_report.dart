import 'package:equatable/equatable.dart';

enum OfficialReportType {
  sacristie,           // Rapport de Sacristie
  serviceDivin,        // Rapport de Service Divin
  communique,          // Communiqué
  listePresence,       // Liste de Présence
  funeraire,           // Rapport Funéraille
  feuilleDeRoute,      // Feuille de Route
  saintsScelles,       // Liste des Saints-Scellés
}

class OfficialReportTemplate extends Equatable {
  final OfficialReportType type;
  final String code;
  final String titre;
  final String description;
  final List<ReportSection> sections;
  final bool requiresSignature;
  final bool requiresApproval;

  const OfficialReportTemplate({
    required this.type,
    required this.code,
    required this.titre,
    required this.description,
    required this.sections,
    this.requiresSignature = true,
    this.requiresApproval = true,
  });

  @override
  List<Object?> get props => [type, code, titre];
}

class ReportSection {
  final String id;
  final String titre;
  final List<ReportField> fields;

  const ReportSection({
    required this.id,
    required this.titre,
    required this.fields,
  });
}

class ReportField {
  final String id;
  final String label;
  final FieldType type;
  final bool obligatoire;
  final List<String>? options;
  final int? maxLines;

  const ReportField({
    required this.id,
    required this.label,
    required this.type,
    this.obligatoire = false,
    this.options,
    this.maxLines = 1,
  });
}

enum FieldType {
  texte,
  texteLong,
  nombre,
  date,
  heure,
  selection,
  checkbox,
  signature,
}

class OfficialReportTemplates {
  static final List<OfficialReportTemplate> all = [
    _sacristie,
    _serviceDivin,
  ];

  static const _sacristie = OfficialReportTemplate(
    type: OfficialReportType.sacristie,
    code: 'SAC-001',
    titre: 'Rapport de Sacristie',
    description: 'Suivi liturgique et matériel avant/après le service',
    sections: [
      ReportSection(
        id: 'pointage',
        titre: 'Pointage des membres',
        fields: [
          ReportField(id: 'presences', label: 'Nombre de présences', type: FieldType.nombre, obligatoire: true),
          ReportField(id: 'visiteurs', label: 'Nombre de visiteurs', type: FieldType.nombre),
        ],
      ),
      ReportSection(
        id: 'liturgie',
        titre: 'Éléments Liturgiques',
        fields: [
          ReportField(id: 'cantique_intro', label: 'Cantique d\'entrée', type: FieldType.texte),
          ReportField(id: 'offrande_fc', label: 'Offrande (FC)', type: FieldType.nombre),
          ReportField(id: 'offrande_usd', label: 'Offrande (USD)', type: FieldType.nombre),
        ],
      ),
    ],
  );

  static const _serviceDivin = OfficialReportTemplate(
    type: OfficialReportType.serviceDivin,
    code: 'SD-002',
    titre: 'Rapport de Service Divin',
    description: 'Compte-rendu spirituel et statistique du culte',
    sections: [
      ReportSection(
        id: 'infos',
        titre: 'Informations Générales',
        fields: [
          ReportField(id: 'officiant', label: 'Ministre Officiant', type: FieldType.texte, obligatoire: true),
          ReportField(id: 'parole', label: 'Texte Biblique', type: FieldType.texteLong),
        ],
      ),
    ],
  );
}
