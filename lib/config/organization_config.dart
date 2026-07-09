import 'package:ecclesiaste/models/hierarchy_models.dart';

class EntityDefinition {
  final EntityLevel level;
  final String name;
  final String description;
  final String code;

  const EntityDefinition({
    required this.level,
    required this.name,
    required this.description,
    required this.code,
  });
}

class CommissionDefinition {
  final CommissionType type;
  final String name;
  final String description;
  final String code;
  final List<String> sousCommissions;

  const CommissionDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.code,
    this.sousCommissions = const [],
  });
}

class OrganizationConfig {
  static const List<EntityDefinition> entities = [
    EntityDefinition(
      level: EntityLevel.communaute,
      name: 'Communauté',
      description: 'Unité locale de l’Église',
      code: 'COM',
    ),
    EntityDefinition(
      level: EntityLevel.district,
      name: 'District',
      description: 'Regroupement de communautés',
      code: 'DIST',
    ),
    EntityDefinition(
      level: EntityLevel.champ,
      name: 'Champ Apostolique',
      description: 'Zone de supervision régionale',
      code: 'CHAMP',
    ),
    EntityDefinition(
      level: EntityLevel.territoriale,
      name: 'Église Territoriale',
      description: 'Entité nationale ou régionale',
      code: 'TER',
    ),
    EntityDefinition(
      level: EntityLevel.internationale,
      name: 'Église Internationale',
      description: 'Direction mondiale (Ecclésiaste)',
      code: 'INT',
    ),
  ];

  static const List<CommissionDefinition> commissions = [
    CommissionDefinition(
      type: CommissionType.ecodim,
      name: 'Commission d’Ecodim',
      description: 'École du Dimanche (enseignement des enfants)',
      code: 'ECODIM',
    ),
    CommissionDefinition(
      type: CommissionType.econfi,
      name: 'Commission d’Econfi',
      description: 'École de Confirmation (préparation des catéchumènes)',
      code: 'ECONFI',
    ),
    CommissionDefinition(
      type: CommissionType.jeunesse,
      name: 'Commission de la Jeunesse',
      description: 'Jeunesse Mixte et Féminine',
      code: 'JNS',
    ),
    CommissionDefinition(
      type: CommissionType.papas,
      name: 'Commission des Papas',
      description: 'Commission des Papas',
      code: 'PAPAS',
    ),
    CommissionDefinition(
      type: CommissionType.mamans,
      name: 'Commission des Mamans',
      description: 'Commission des Mamans',
      code: 'MAMANS',
    ),
    CommissionDefinition(
      type: CommissionType.aines,
      name: 'Commission des Aînés',
      description: 'Frères et sœurs de plus de 65 ans et FM en retraite',
      code: 'AINES',
    ),
    CommissionDefinition(
      type: CommissionType.musique,
      name: 'Commission Musique',
      description: 'Direction technique et Orchestre',
      code: 'MUS',
      sousCommissions: ['Direction technique', 'Orchestre'],
    ),
    CommissionDefinition(
      type: CommissionType.presseMediasSonorisation,
      name: 'Commission Presse, Médias et Sonorisation',
      description: 'Communication et technique',
      code: 'PRESSE',
    ),
    CommissionDefinition(
      type: CommissionType.josephArimathee,
      name: 'Commission des Joseph d’Arimathée',
      description: 'Commission des Piliers',
      code: 'ARIM',
    ),
    CommissionDefinition(
      type: CommissionType.securiteProtocole,
      name: 'Commission Sécurité et Protocole',
      description: 'Sécurité et organisation',
      code: 'SEC',
    ),
    CommissionDefinition(
      type: CommissionType.medicale,
      name: 'Commission Médicale',
      description: 'Service médical et assistance sanitaire',
      code: 'MED',
    ),
    CommissionDefinition(
      type: CommissionType.construction,
      name: 'Commission Construction',
      description: 'Bâtiments et infrastructures',
      code: 'CONST',
    ),
  ];

  static EntityDefinition getEntity(EntityLevel level) {
    return entities.firstWhere((item) => item.level == level);
  }

  static CommissionDefinition getCommission(CommissionType type) {
    return commissions.firstWhere(
      (item) => item.type == type,
      orElse: () => const CommissionDefinition(
        type: CommissionType.none,
        name: 'Aucune commission',
        description: 'Commission non renseignée.',
        code: 'NONE',
      ),
    );
  }
}

