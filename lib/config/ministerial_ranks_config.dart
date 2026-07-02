import '../models/hierarchy_models.dart';

class MinisterialRankDefinition {
  final UserRole role;
  final String label;
  final String scope;
  final String roleDescription;
  final List<String> tasks;

  const MinisterialRankDefinition({
    required this.role,
    required this.label,
    required this.scope,
    required this.roleDescription,
    required this.tasks,
  });
}

class MinisterialRanksConfig {
  static const List<MinisterialRankDefinition> ranks = [
    MinisterialRankDefinition(
      role: UserRole.apotrePatriarche,
      label: 'Apôtre Patriarche',
      scope: 'Église mondiale',
      roleDescription:
          'Plus haut niveau de leadership. Il veille à la direction spirituelle mondiale, à la continuité de la foi apostolique et à l’orientation générale de l’Église.',
      tasks: [
        'Diriger l’Église à l’échelle mondiale.',
        'Prendre les décisions doctrinales importantes.',
        'Nommer les autres apôtres et définir leurs responsabilités.',
        'Préserver la tradition apostolique.',
        'Décider des changements majeurs dans l’organisation de l’Église.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.apotreDistrict,
      label: 'Apôtre de District',
      scope: 'Plusieurs régions',
      roleDescription:
          'Responsable de plusieurs régions. Il garantit le respect de la doctrine et coordonne les activités apostoliques.',
      tasks: [
        'Superviser plusieurs districts.',
        'Ordiner et superviser les ministres et leaders locaux.',
        'Donner les enseignements doctrinaux dans son district.',
        'Organiser des conférences et événements pour fortifier la foi.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.apotreResponsable,
      label: 'Apôtre Responsable',
      scope: 'Zone géographique ou mission spécifique',
      roleDescription:
          'Supervise une grande zone géographique ou une responsabilité spécifique au sein de l’Église.',
      tasks: [
        'Assurer la gestion spirituelle et administrative de son secteur.',
        'Organiser les services et événements spéciaux.',
        'Enseigner et renforcer la doctrine.',
        'Guider les communautés locales et former les futurs ministres.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.apotre,
      label: 'Apôtre',
      scope: 'Champ d’activité apostolique',
      roleDescription:
          'Responsable d’un champ d’activité apostolique, avec mission de conduite spirituelle et de propagation de l’Évangile.',
      tasks: [
        'Prêcher l’Évangile et enseigner les membres.',
        'Diriger les services divins, prières et sacrements.',
        'Former et ordonner les autres ministres.',
        'Conduire des missions apostoliques.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.eveque,
      label: 'Évêque',
      scope: 'Centre-ville',
      roleDescription:
          'Responsable du bien-être spirituel des membres dans son secteur et du suivi des congrégations locales.',
      tasks: [
        'Superviser les congrégations locales et leur croissance spirituelle.',
        'Guider les prêtres et diacres dans leur travail spirituel.',
        'Donner des bénédictions et ordonner des ministres inférieurs.',
        'Organiser des réunions et conférences spirituelles.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.ancien,
      label: 'Ancien',
      scope: 'District',
      roleDescription:
          'Responsable d’un district et acteur clé de l’encadrement spirituel et administratif.',
      tasks: [
        'Assister les prêtres dans les services divins et sacrements.',
        'Aider à la gestion des activités spirituelles de la congrégation.',
        'Enseigner la foi et guider les membres.',
        'Assurer un soutien pastoral de proximité.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.lead,
      label: 'Lead',
      scope: 'Circonscription',
      roleDescription:
          'Responsable du suivi d’une circonscription avec un accent sur le contrôle et la coordination des activités.',
      tasks: [
        'Vérifier les activités de la circonscription.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.berger,
      label: 'Berger',
      scope: 'Sous-district',
      roleDescription:
          'Ministre chargé de l’accompagnement pastoral, spirituel et émotionnel des membres.',
      tasks: [
        'Accompagner personnellement et spirituellement les membres.',
        'Apporter du réconfort dans les épreuves.',
        'Participer à la gestion de la congrégation et des activités spirituelles.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.evangeliste,
      label: 'Évangéliste',
      scope: 'Centre',
      roleDescription:
          'Responsable du témoignage, de l’évangélisation et de l’encadrement des nouveaux croyants.',
      tasks: [
        'Prêcher l’Évangile dans les rassemblements et missions.',
        'Organiser des campagnes de sensibilisation.',
        'Formation et enseignement des nouveaux convertis.',
        'Faire connaître la parole de Dieu hors de la congrégation.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.pretre,
      label: 'Prêtre',
      scope: 'Congrégation',
      roleDescription:
          'Chargé de l’administration des sacrements, de la prédication et de la conduite des services divins.',
      tasks: [
        'Célébrer le service divin et administrer les sacrements.',
        'Prêcher et enseigner la parole de Dieu.',
        'Diriger les cultes et réunions spirituelles.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.diacre,
      label: 'Diacre',
      scope: 'Congrégation',
      roleDescription:
          'Soutient le prêtre dans les services religieux et l’organisation des activités de l’Église.',
      tasks: [
        'Assister le prêtre dans la célébration des sacrements.',
        'Participer à l’accueil des membres et à la collecte des offrandes.',
        'Aider à l’organisation et au déroulement des activités liturgiques.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.sousDiacre,
      label: 'Sous-Diacre',
      scope: 'Congrégation',
      roleDescription:
          'Ministre d’appui important pour les tâches liturgiques et administratives.',
      tasks: [
        'Assister les diacres et prêtres dans les activités liturgiques.',
        'Préparer le matériel du culte et de la Sainte-Cène.',
        'Aider à l’organisation des cultes.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.frereCharge,
      label: 'Frère Chargé',
      scope: 'Congrégation',
      roleDescription:
          'Responsable de tâches spécifiques pour soutenir l’organisation et la régularité des services.',
      tasks: [
        'Assister dans la gestion administrative de la congrégation.',
        'Veiller au bon déroulement des services divins et activités communautaires.',
      ],
    ),
    MinisterialRankDefinition(
      role: UserRole.conductrice,
      label: 'Conductrice',
      scope: 'Congrégation',
      roleDescription:
          'Responsable de l’animation et de l’accompagnement spirituel des groupes féminins.',
      tasks: [
        'Organiser des cultes et événements spirituels pour les femmes.',
        'Gérer les groupes de prière féminins.',
        'Accompagner spirituellement les femmes de la congrégation.',
      ],
    ),
  ];

  static MinisterialRankDefinition? findByRole(UserRole role) {
    for (final definition in ranks) {
      if (definition.role == role) {
        return definition;
      }
    }
    return null;
  }
}

