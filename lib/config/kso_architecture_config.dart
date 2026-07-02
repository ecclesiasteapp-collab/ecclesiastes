
import 'package:hive/hive.dart';
import '../utils/entite_types.dart';
import '../config/organization_config.dart';

class DocumentProfileDefinition {
  final String code;
  final String label;
  final List<String> directories;

  const DocumentProfileDefinition({
    required this.code,
    required this.label,
    required this.directories,
  });
}

class KsoArchitectureConfig {
  static const String champId = 'champ_kso';
  static const String champNom = 'Champ Apostolique KSO';
  static const String champResponsable = 'Apôtre NGOLO Emmanuel';
  static int totalDistricts = 0; // Sera initialisé dynamiquement
  static int totalCommunautes = 0; // Sera initialisé dynamiquement

  static Future<void> initializeCounts() async {
    final entitesBox = await Hive.openBox<Map>('entites');
    Map? champKso;
    for (final entity in entitesBox.values) {
      if (entity['id'] == champId &&
          EntiteTypes.normalize(entity['type']?.toString()) ==
              EntiteTypes.champApostolique) {
        champKso = entity;
        break;
      }
    }

    if (champKso != null) {
      totalDistricts = champKso['nombre_districts'] ?? 0;
      totalCommunautes = champKso['nombre_communautes'] ?? 0;
    }
  }

  static const List<DocumentProfileDefinition> profilsDocumentaires = [
    DocumentProfileDefinition(
      code: 'ministre',
      label: 'Ministres',
      directories: [
        'assets/ministres/directives/',
        'assets/ministres/pensee_directrice/',
        'assets/ministres/liturgie/',
        'assets/ministres/rapports/',
      ],
    ),
    DocumentProfileDefinition(
      code: 'formateur',
      label: 'Formateurs / Commissions',
      directories: [
        'assets/commissions/',
        'assets/librairie/formations/commissions/',
        'assets/librairie/programmes/',
      ],
    ),
    DocumentProfileDefinition(
      code: 'membre',
      label: 'Membres',
      directories: [
        'assets/librairie/catechisme/',
        'assets/librairie/cantiques/',
        'assets/librairie/pensee_directrice/',
      ],
    ),
  ];

    // Cette méthode devra être refactorisée pour charger les districts dynamiquement
  static List<String> get nomsDistricts => [];

  static List<Map<String, dynamic>> buildCommissionTemplatesForCommunity({
    required String communauteId,
    required String communauteNom,
  }) {
    return OrganizationConfig.commissions.map((commission) {
      return {
        'id': '${communauteId}_${commission.code.toLowerCase()}',
        'communaute_id': communauteId,
        'communaute_nom': communauteNom,
        'commission': commission.type.name,
        'responsable_nom': null,
        'adjoint_nom': null,
        'sous_commissions': commission.sousCommissions,
      };
    }).toList();
  }
}

