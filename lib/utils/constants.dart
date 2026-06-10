class AppConstants {
  static const String appName = "Ecclesiastes";
  static const String egliseNom = "ÉGLISE NÉO-APOSTOLIQUE EN RDC OUEST";
  static const String directivesVersion = 'v3 - 24/11/2023';

  // Workflow de validation (heures)
  static const int validationDelaiCommunaute = 48;
  static const int validationDelaiDistrict = 72;
  static const int validationDelaiChamp = 120;

  // Bibliothèque officielle
  static const List<String> documentsBibliotheque = [
    'Directives Ministres.pdf',
    'Manuel Catéchisme Prof.pdf',
    'Recueil Cantiques.pdf',
    'Guide Formation Ministres.pdf',
    'Cahier Élève Ecodim.pdf',
    'Vade-mecum Sacristie.pdf',
    'Guide Pastoral.pdf',
    'Reglement Interieur.pdf',
  ];

  // Les 12 commissions officielles
  static const List<String> commissions = [
    "Commission d’Ecodim",
    "Commission d’Econfi",
    "Commission de la Jeunesse",
    "Commission des Papas",
    "Commission des Mamans",
    "Commission des Aînés (Frères et sœurs de plus de 65 ans et FM en retraite)",
    "Commission Musique",
    "Commission Presse, Médias et Sonorisation",
    "Commission des Joseph d’Arimathée ou des Piliers",
    "Commission Sécurité et Protocole",
    "Commission Médicale",
    "Commission Construction",
  ];

  // Hiérarchie des Ministères
  static const List<String> ministeres = [
    'Apôtre Patriarche',
    'Apôtre de District',
    'Apôtre Responsable',
    'Apôtre',
    'Évêque (ministère sacerdotal)',
    'Ancien (ministère sacerdotal)',
    'Lead ou évangéliste de district (ministère sacerdotal)',
    'Berger (ministère sacerdotal)',
    'Évangéliste (ministère sacerdotal)',
    'Prêtre (ministère sacerdotal)',
    'Diacre',
    'Sous-Diacre',
  ];

  // Rôles de gestion des entités et ses gestionnaires
  static const List<String> rolesGestion = [
    'Responsable de communauté (ministère sacerdotal)',
    'Suppléant responsable de communauté (ministère sacerdotal)',
    'Responsable de district (ministère sacerdotal)',
    'Suppléant responsable de district (ministère sacerdotal)',
    'Apôtre du champ apostolique',
    'Apôtre du champ apostolique adjoint',
    'Apôtre de district',
    'Apôtre de district adjoint',
    'Responsable de commission',
    'Secrétaire',
    'Trésorier',
    'Membre',
  ];

  // Rôles Applicatifs (Matrice d'Accès CDCF)
  static const String roleSuperAdmin = 'SUPER_ADMIN';
  static const String roleResponsable = 'RESPONSABLE';
  static const String roleMinistre = 'MINISTRE';
  static const String roleCommission = 'COMMISSION';
  static const String roleMembre = 'MEMBRE';

  static const List<String> rolesConnexion = [
    'Membre',
    'Commission',
    'Ministre',
    'Responsable d\'entité',
  ];

  static const List<String> niveauxGeographiques = [
    'Territoire',
    'Champ',
    'District',
    'Communauté',
  ];

  /// 12 commissions avec métadonnées pour le tableau de bord.
  static const List<Map<String, dynamic>> commissionsDashboard = [
    {'id': 1, 'nom': 'Ecodim', 'court': 'Ecodim', 'section': 'local', 'icon': 0xe318, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 2, 'nom': 'Econfi', 'court': 'Econfi', 'section': 'local', 'icon': 0xe80c, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 3, 'nom': 'Jeunesse', 'court': 'Jeunesse', 'section': 'local', 'icon': 0xe7ef, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 4, 'nom': 'Papas', 'court': 'Papas', 'section': 'local', 'icon': 0xe7fd, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 5, 'nom': 'Mamans', 'court': 'Mamans', 'section': 'local', 'icon': 0xe87e, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 6, 'nom': 'Aînés', 'court': 'Aînés', 'section': 'local', 'icon': 0xe8d3, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 7, 'nom': 'Musique', 'court': 'Musique', 'section': 'tech', 'icon': 0xe405, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 8, 'nom': 'Presse & Sono', 'court': 'Presse & Sono', 'section': 'tech', 'icon': 0xe04f, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 9, 'nom': "Joseph d'Arimathée", 'court': "Joseph d'Arimathée", 'section': 'tech', 'icon': 0xe869, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 10, 'nom': 'Sécurité', 'court': 'Sécurité', 'section': 'tech', 'icon': 0xe32a, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 11, 'nom': 'Médicale', 'court': 'Médicale', 'section': 'tech', 'icon': 0xe3f3, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
    {'id': 12, 'nom': 'Construction', 'court': 'Construction', 'section': 'tech', 'icon': 0xe869, 'responsable': 'À définir', 'pct': 0, 'statut': 'Actif'},
  ];

  static const int ageRetraite = 65;

  static const List<String> typesOrdination = [
    'Ordination',
    'Mandatement',
    'Nomination',
  ];

  static const List<String> droitsMinistres = [
    'Consentement préalable avant toute ordination, mandatement ou nomination',
    'Droit à l\'information pour accomplir leurs tâches',
    'Participation aux réunions et services divins ministériels',
    'Protection et sollicitude en cas de conflits liés à l\'activité',
    'Pastorale personnelle pour le ministre et sa famille',
    'Droit d\'être entendu avant toute décision les concernant',
    'Droit à la retraite à 65 ans ou de manière anticipée',
    'Droit de résigner leur ministère',
  ];

  static const List<String> devoirsMinistres = [
    'Communion avec l\'apostolat, ne pas agir par leurs propres ressources',
    'Annoncer l\'Évangile dans sa pureté, respecter la doctrine du Catéchisme',
    'Conformité des actes et paroles à la foi, en public comme en privé',
    'Loyauté, impartialité, désintéressement et conduite exemplaire',
    'Confidentialité absolue sur les entretiens pastoraux et réunions',
    'Protection contre les violences sexuelles, signalement immédiat',
    'Retenue politique : ne pas influencer les convictions politiques des membres',
  ];
}
