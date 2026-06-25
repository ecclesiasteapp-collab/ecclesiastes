import '../models/hierarchy_models.dart';

class MinistryDefinition {
  final UserRole role;
  final String title;
  final String description;
  final List<String> tasks;

  const MinistryDefinition({
    required this.role,
    required this.title,
    required this.description,
    required this.tasks,
  });
}

class MinistryConfig {
  static const List<MinistryDefinition> ranks = [
    MinistryDefinition(
      role: UserRole.apotrePatriarche,
      title: 'APÔTRE PATRIARCHE',
      description: 'C’est le plus haut niveau de leadership dans l’Église Néo-Apostolique. Il est à l’échelle mondiale. Il est responsable de la direction spirituelle, de la continuité de la foi apostolique, et de l’orientation générale de l’Église.',
      tasks: [
        'Diriger l’Église à l’échelle mondiale.',
        'Prendre les décisions doctrinales importantes.',
        'Nommer les autres Apôtres et leurs responsabilités.',
        'Assurer la préservation de la tradition apostolique.',
        'Prendre des décisions sur les changements majeurs dans l\'organisation de l’Église.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.apotreDistrict,
      title: 'APÔTRE DE DISTRICT',
      description: 'Responsable de plusieurs régions. Il veille à ce que la doctrine et les pratiques apostoliques soient respectées. Il coordonne les activités et supervise les Apôtres responsables et autres ministères locaux.',
      tasks: [
        'Superviser plusieurs districts.',
        'Ordiner et superviser les ministres et les leaders locaux.',
        'Donner des enseignements doctrinaux dans son district.',
        'Organiser des conférences et des événements pour renforcer la foi de la communauté.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.apotreResponsable,
      title: 'APÔTRE RESPONSABLE',
      description: 'Il supervise une zone géographique ou une tâche spécifique au sein de l’Église. Il joue un rôle de leadership important dans son secteur.',
      tasks: [
        'Assurer la gestion spirituelle et administrative d’un secteur particulier (une grande ville).',
        'Organiser les services et les événements spéciaux.',
        'Enseigner et renforcer la doctrine.',
        'Guider les communautés locales et former les futurs ministres.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.apotre,
      title: 'APÔTRE',
      description: 'Responsable de CAA (champ d\'activité).',
      tasks: [
        'Prêcher l’Évangile et enseigner les membres.',
        'Diriger les services divins, les prières et les sacrements.',
        'Assurer la formation et l’ordination des autres ministres.',
        'Diriger des missions apostoliques pour la propagation de l’Évangile.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.eveque,
      title: 'ÉVÊQUE',
      description: 'Responsable de centre ville, Il est responsable du bien-être spirituel des membres de son district.',
      tasks: [
        'Superviser les congrégations locales et assurer leur croissance spirituelle.',
        'Guider les prêtres et les diacres dans leur travail spirituel.',
        'Donner des bénédictions et ordonner des ministres inférieurs.',
        'Organiser des événements spirituels dans sa région (réunions, conférences, ).',
      ],
    ),
    MinistryDefinition(
      role: UserRole.ancien,
      title: 'ANCIEN',
      description: 'Responsable d\'un district. Il est souvent responsable de certaines tâches administratives et spirituelles au sein de la congrégation.',
      tasks: [
        'Assister les prêtres dans la conduite des services divins et des sacrements.',
        'Aider à la gestion des activités spirituelles dans la congrégation.',
        'Enseigner la foi et guider les membres dans leur vie spirituelle.',
        'Fournir un soutien pastoral aux membres de la congrégation.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.lude,
      title: 'LUDE',
      description: 'Responsable de circo.',
      tasks: [
        'Vérification des activités de circo.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.berger,
      title: 'BERGER',
      description: 'Responsable de sous-district. Le Berger est un ministre chargé de l’accompagnement pastoral des membres de la congrégation. Il assure le soutien spirituel et émotionnel des membres, en particulier dans les moments difficiles.',
      tasks: [
        'Fournir un accompagnement personnel et spirituel aux membres.',
        'Apporter du réconfort aux membres de l\'Église dans les épreuves.',
        'Participer à la gestion de la congrégation et des activités spirituelles.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.evangeliste,
      title: 'ÉVANGÉLISTE',
      description: 'L\'Évangéliste est responsable du centre.',
      tasks: [
        'Prêcher l’Évangile dans les rassemblements et les missions.',
        'Organiser des campagnes de sensibilisation pour attirer de nouveaux croyants.',
        'Former et enseigner les nouveaux convertis.',
        'Faire connaître la parole de Dieu dans des lieux extérieurs à la congrégation.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.pretre,
      title: 'PRÊTRE',
      description: 'Le Prêtre est chargé de l\'administration des sacrements dans la congrégation. Il est responsable de la prédication, de la Sainte-Cène et des cérémonies de l’Église.',
      tasks: [
        'Célébrer le service divin et administrer les sacrements.',
        'Prêcher et enseigner les membres sur la parole de Dieu.',
        'Diriger les cultes et organiser les réunions spirituelles.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.diacre,
      title: 'DIACRE',
      description: 'Le Diacre est un ministre qui soutient le prêtre dans les services religieux et dans la gestion des activités de l’Église.',
      tasks: [
        'Assister le prêtre dans la célébration des sacrements.',
        'Participer à l’accueil des membres et à la distribution des offrandes.',
        'Aider à organiser et à mener les activités liturgiques.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.sousDiacre,
      title: 'SOUS-DIACRE',
      description: 'Le Sous-Diacre est un ministre de moindre niveau, mais il joue un rôle important dans les tâches liturgiques et administratives. Il soutient les diacres et prêtres dans leurs fonctions.',
      tasks: [
        'Assister les diacres et prêtres dans les activités liturgiques.',
        'Veiller à la préparation matérielle (disposition des objets liturgiques, préparation de la Sainte-Cène).',
        'Aider à l\'organisation des cultes.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.frereCharge,
      title: 'FRÈRE CHARGÉ',
      description: 'Le Frère Chargé a la responsabilité de certaines tâches spécifiques au sein de la congrégation, comme l’assistance dans les services et le soutien aux ministères plus élevés.',
      tasks: [
        'Assister dans la gestion administrative de la congrégation.',
        'Veiller au bon déroulement des services divins et des activités communautaires.',
      ],
    ),
    MinistryDefinition(
      role: UserRole.conductrice,
      title: 'CONDUCTRICE',
      description: 'La Conductrice est responsable de la gestion des aspects pratiques de la congrégation, en particulier la gestion des services religieux destinés aux femmes.',
      tasks: [
        'Organiser des cultes et des événements spirituels pour les femmes.',
        'Assurer la gestion des groupes de prière féminins.',
        'Accompagner spirituellement les femmes de la congrégation.',
      ],
    ),
  ];

  static MinistryDefinition getRank(UserRole role) {
    return ranks.firstWhere((r) => r.role == role, orElse: () => ranks.last);
  }
}
