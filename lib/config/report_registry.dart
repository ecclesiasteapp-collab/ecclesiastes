import 'package:flutter/material.dart';
import '../models/report_config.dart';

class ReportRegistry {
  static const Map<String, ReportConfig> all = {
    // 1. SACRISTIE
    'sacristie': ReportConfig(
      id: 'sacristie', title: 'Rapport de Sacristie', icon: Icons.cleaning_services,
      kpis: [KPIConfig(label: 'Membres présents', target: 80, unit: '%', directiveRef: '§13.5')],
      fields: [
        ReportField(key: 'h1', label: 'I. POINTAGE DES MEMBRES', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.number),
        ReportField(key: 'field_2', label: '2', type: FieldType.number),
        ReportField(key: 'field_3', label: '3', type: FieldType.number),
        ReportField(key: 'field_4', label: '4', type: FieldType.number),
        ReportField(key: 'h2', label: 'II. ORDRE DANS L\'ÉGLISE', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'field_3', label: '3', type: FieldType.text),
        ReportField(key: 'field_4', label: '4', type: FieldType.text),
        ReportField(key: 'field_5', label: '5', type: FieldType.text),
        ReportField(key: 'field_6', label: '6', type: FieldType.text),
        ReportField(key: 'h3', label: 'III. DÉPOUILLEMENT DES OFFRANDES', type: FieldType.header),
        ReportField(key: 'field_1', label: '1 (FC)', type: FieldType.number),
        ReportField(key: 'field_2', label: '2 (Devise)', type: FieldType.number),
        ReportField(key: 'field_3', label: '3', type: FieldType.text),
        ReportField(key: 'field_4', label: '4', type: FieldType.text),
        ReportField(key: 'h4a', label: 'IV. OUVERTURE ET COUVERTURE DES CALICES - A. GAUCHE', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'h4b', label: 'IV. OUVERTURE ET COUVERTURE DES CALICES - B. DROITE', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'h5a', label: 'V. DISTRIBUTION DE SAINTE-CÈNE - A. GAUCHE', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'h5b', label: 'V. DISTRIBUTION DE SAINTE-CÈNE - B. DROITE', type: FieldType.header),
        ReportField(key: 'field_3', label: '3', type: FieldType.text),
        ReportField(key: 'field_4', label: '4', type: FieldType.text),
        ReportField(key: 'h6', label: 'VI. ÉTABLISSEMENT DE RAPPORT', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'h7', label: 'VII. CAS: MALADE', type: FieldType.header),
        ReportField(key: 'field_1', label: '1', type: FieldType.text),
        ReportField(key: 'field_2', label: '2', type: FieldType.text),
        ReportField(key: 'field_3', label: '3', type: FieldType.text),
        ReportField(key: 'field_4', label: '4', type: FieldType.text),
        ReportField(key: 'field_5', label: '5', type: FieldType.text),
        ReportField(key: 'field_6', label: '6', type: FieldType.text),
        ReportField(key: 'h8', label: 'VIII. RÉCEPTION', type: FieldType.header),
        ReportField(key: 'field_Détails', label: 'Détails de réception', type: FieldType.textarea),
      ],
      recommendations: ['Vérifier les calices avant chaque SD', 'Signaler immédiatement tout incident technique'],
      libraryRefs: ['Directives §4.2.1', 'Guide Sacristie v2'],
    ),

    // 2. SERVICE DIVIN
    'service_divin': ReportConfig(
      id: 'service_divin', title: 'Rapport de Service Divin', icon: Icons.church,
      kpis: [KPIConfig(label: 'Durée moyenne', target: 60, unit: 'min', directiveRef: '§4.4')],
      fields: [
        ReportField(key: 'h1', label: 'INFORMATIONS GÉNÉRALES', type: FieldType.header),
        ReportField(key: 'jour', label: 'Jour', type: FieldType.dropdown, options: ['Dimanche', 'Semaine'], required: true),
        ReportField(key: 'date', label: 'Date', type: FieldType.date, required: true),
        ReportField(key: 'type', label: 'Type de service', type: FieldType.dropdown, options: ['SD', 'RF', 'SJ', 'S', 'SE', 'SF', 'MA', 'C'], required: true),
        ReportField(key: 'heureDebut', label: 'Heure début', type: FieldType.text, required: true),
        ReportField(key: 'heureFin', label: 'Heure fin', type: FieldType.text, required: true),
        
        ReportField(key: 'h2', label: 'DÉTAILS DU SERVICE', type: FieldType.header),
        ReportField(key: 'cantique', label: 'Cantique d\'introduction', type: FieldType.text, required: true),
        ReportField(key: 'texteBiblique', label: 'Texte biblique', type: FieldType.text, required: true),
        ReportField(key: 'officiant', label: 'Officiant', type: FieldType.text, required: true),
        
        ReportField(key: 'h3', label: 'PRÉSENCES', type: FieldType.header),
        ReportField(key: 'totalPresences', label: 'Total présences', type: FieldType.number, required: true),
        ReportField(key: 'membres', label: 'Membres', type: FieldType.number),
        ReportField(key: 'visiteurs', label: 'Visiteurs', type: FieldType.number),
        
        ReportField(key: 'h4', label: 'OFFRANDES', type: FieldType.header),
        ReportField(key: 'offrandeFC', label: 'Offrande FC', type: FieldType.number),
        ReportField(key: 'offrandeDevise', label: 'Offrande Devise', type: FieldType.number),
        ReportField(key: 'numeroRecu', label: 'N° du Reçu', type: FieldType.text),
        
        ReportField(key: 'h5', label: 'ACTES', type: FieldType.header),
        ReportField(key: 'bapteme', label: 'Saint Baptême', type: FieldType.number),
        ReportField(key: 'scelle', label: 'Saint Scellé', type: FieldType.number),
        ReportField(key: 'confirmation', label: 'Confirmation', type: FieldType.number),
        
        ReportField(key: 'h6', label: 'ORDINATIONS', type: FieldType.header),
        ReportField(key: 'ordinationAD', label: 'AD', type: FieldType.number),
        ReportField(key: 'ordinationEVD', label: 'EVD', type: FieldType.number),
        ReportField(key: 'ordinationB', label: 'B', type: FieldType.number),
        ReportField(key: 'ordinationEV', label: 'EV', type: FieldType.number),
        ReportField(key: 'ordinationR', label: 'R', type: FieldType.number),
        ReportField(key: 'ordinationP', label: 'P', type: FieldType.number),
        ReportField(key: 'ordinationD', label: 'D', type: FieldType.number),
        
        ReportField(key: 'h7', label: 'RETRAITES', type: FieldType.header),
        ReportField(key: 'retraiteAD', label: 'AD', type: FieldType.number),
        ReportField(key: 'retraiteEVD', label: 'EVD', type: FieldType.number),
        ReportField(key: 'retraiteB', label: 'B', type: FieldType.number),
        ReportField(key: 'retraiteEV', label: 'EV', type: FieldType.number),
        ReportField(key: 'retraiteR', label: 'R', type: FieldType.number),
        ReportField(key: 'retraiteP', label: 'P', type: FieldType.number),
        ReportField(key: 'retraiteD', label: 'D', type: FieldType.number),
      ],
      recommendations: ['Respecter la liturgie officielle (§4.5)', 'Limiter la prédication à 15-20 min'],
      libraryRefs: ['Directives §4.5', 'Liturgie officielle'],
    ),

    // 3. SAINTS-SCELLES
    'saints_scelles': ReportConfig(
      id: 'saints_scelles', title: 'Liste des Saints-Scellés', icon: Icons.verified_user,
      kpis: [KPIConfig(label: 'Taux de conformité', target: 100, unit: '%', directiveRef: '§6.3')],
      fields: [
        ReportField(key: 'total', label: 'Total âmes scellées', type: FieldType.number, required: true),
        ReportField(key: 'liste_noms', label: 'Noms & Post-noms', type: FieldType.textarea, maxLines: 5),
        ReportField(key: 'apotre', label: 'Nom de l\'Apôtre', type: FieldType.text, required: true),
      ],
      recommendations: ['Vérifier l\'âge & consentement parental (§6.3.1)', 'Confidentialité stricte (§3.20.6)'],
      libraryRefs: ['Directives §6.3', 'Registre des sacrements'],
    ),

    // 4. FUNERAILLE
    'funeraille': ReportConfig(
      id: 'funeraille', title: 'Rapport de Funérailles', icon: Icons.local_florist,
      kpis: [KPIConfig(label: 'Respect délais', target: 100, unit: '%', directiveRef: '§4.6.7')],
      fields: [
        ReportField(key: 'defunt_nom', label: 'Nom du défunt', type: FieldType.text, required: true),
        ReportField(key: 'date_deces', label: 'Date décès', type: FieldType.date, required: true),
        ReportField(key: 'officiant', label: 'Officiant', type: FieldType.text, required: true),
      ],
      recommendations: ['Accompagnement familial prioritaire', 'Archiver le curriculum vitae'],
      libraryRefs: ['Directives §4.6.7', 'Guide Pastoral Funérailles'],
    ),

    // 5. COMMUNIQUE
    'communique': ReportConfig(
      id: 'communique', title: 'Communiqué Officiel', icon: Icons.announcement,
      kpis: [KPIConfig(label: 'Points publiés', target: 20, unit: '', directiveRef: '§9')],
      fields: [
        ReportField(key: 'contenu', label: 'Points du communiqué', type: FieldType.textarea, maxLines: 10),
      ],
      recommendations: ['Valider par le conducteur avant diffusion', 'Respecter le ton pastoral'],
      libraryRefs: ['Directives §9.2', 'Charte communication'],
    ),

    // 6. PRESENCE REUNION
    'presence_reunion': ReportConfig(
      id: 'presence_reunion', title: 'Liste de Présence', icon: Icons.how_to_reg,
      kpis: [KPIConfig(label: 'Taux participation', target: 75, unit: '%', directiveRef: '§3.20.7')],
      fields: [
        ReportField(key: 'h1', label: 'INFORMATIONS RÉUNION', type: FieldType.header),
        ReportField(key: 'jourDate', label: 'Jour et Date', type: FieldType.text, required: true),
        ReportField(key: 'heureDebut', label: 'Heure début', type: FieldType.text, required: true),
        ReportField(key: 'heureFin', label: 'Heure fin', type: FieldType.text, required: true),
        ReportField(key: 'tenuePar', label: 'Tenue par', type: FieldType.text, required: true),
        ReportField(key: 'telephone', label: 'Téléphone', type: FieldType.text),
        ReportField(key: 'priereOuverture', label: 'Prière d\'ouverture', type: FieldType.text),
        ReportField(key: 'offrande', label: 'Offrande', type: FieldType.number),
        ReportField(key: 'priereFinale', label: 'Prière finale', type: FieldType.text),
        ReportField(key: 'h2', label: 'LISTE DES PRÉSENTS', type: FieldType.header),
        ReportField(key: 'liste_participants', label: 'Participants (Noms et Ministères)', type: FieldType.textarea, maxLines: 15),
      ],
      recommendations: ['Noter absences excusées', 'Archiver pour audit ministériel'],
      libraryRefs: ['Directives §3.20.7', 'Règlement intérieur'],
    ),

    // 7. FEUILLE DE ROUTE
    'feuille_route': ReportConfig(
      id: 'feuille_route', title: 'Feuille de Route', icon: Icons.route,
      kpis: [KPIConfig(label: 'Autorisations valides', target: 100, unit: '%', directiveRef: '§3.4.2')],
      fields: [
        ReportField(key: 'autorise', label: 'Personne autorisée', type: FieldType.text, required: true),
        ReportField(key: 'trajet', label: 'Trajet (De → À)', type: FieldType.text, required: true),
        ReportField(key: 'motif', label: 'Motif', type: FieldType.textarea, maxLines: 2),
      ],
      recommendations: ['Obtenir consentement apostolat si hors champ (§3.4.2)'],
      libraryRefs: ['Directives §3.4.2', 'Formulaire officiel'],
    ),

    // 8. VISITE PASTORALE
    'visite_pastorale': ReportConfig(
      id: 'visite_pastorale', title: 'Rapport de Visite Pastorale', icon: Icons.home,
      kpis: [KPIConfig(label: 'Visites/mois', target: 15, unit: '', directiveRef: '§7.5')],
      fields: [
        ReportField(key: 'visiteurs', label: 'Visiteur(s)', type: FieldType.text, required: true),
        ReportField(key: 'motif', label: 'Motif', type: FieldType.dropdown, options: ['Régulière', 'Maladie', 'Deuil', 'Soutien', 'Nouveau membre', 'Préparation sacrement', 'Autre'], required: true),
        ReportField(key: 'contenu', label: 'Contenu (Confidentiel)', type: FieldType.textarea, maxLines: 4),
      ],
      recommendations: ['Respecter §3.20.6 Confidentialité', 'Ne pas divulguer sans consentement'],
      libraryRefs: ['Directives §7.5', 'Guide Entretien Pastoral'],
    ),

    // 9. ECODIM
    'ecodim': ReportConfig(
      id: 'ecodim', title: 'Rapport École du Dimanche (Ecodim)', icon: Icons.child_care,
      kpis: [
        KPIConfig(label: 'Présence enfants', target: 85, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Moniteurs formés', target: 4, unit: '', directiveRef: 'Annexe 5')
      ],
      fields: [
        ReportField(key: 'header_age', label: '1. EFFECTIFS PAR TRANCHE D\'ÂGE', type: FieldType.header),
        ReportField(key: 'age_3_5', label: 'Enfants (3-5 ans)', type: FieldType.number),
        ReportField(key: 'age_6_8', label: 'Enfants (6-8 ans)', type: FieldType.number),
        ReportField(key: 'age_9_11', label: 'Enfants (9-11 ans)', type: FieldType.number),
        ReportField(key: 'age_12_14', label: 'Jeunes (12-14 ans)', type: FieldType.number),
        ReportField(key: 'header_pedagogie', label: '2. PÉDAGOGIE & MATÉRIEL', type: FieldType.header),
        ReportField(key: 'lecon_numero', label: 'Leçon N° traitée', type: FieldType.number, required: true),
        ReportField(key: 'lecon_titre', label: 'Titre de la leçon', type: FieldType.text),
        ReportField(key: 'cahier_eleve', label: 'Utilisation du cahier "Moi aussi..."', type: FieldType.checkbox, options: ['Cahier distribué et utilisé']),
        ReportField(key: 'manuel_maitre', label: 'Utilisation du Manuel du Maître', type: FieldType.checkbox, options: ['Méthode dialogique respectée']),
        ReportField(key: 'header_resolution', label: '3. RÉSOLUTION & SPIRITUEL', type: FieldType.header),
        ReportField(key: 'resolution', label: 'Résolution prise (Moi aussi, je veux...)', type: FieldType.textarea, maxLines: 2, required: true),
      ],
      recommendations: ['Utiliser cahier "Moi aussi..." (§7.8)', 'Préparer la leçon 48h avant'],
      libraryRefs: ['Manuel Catéchisme Prof', 'Directives §7.8'],
    ),

    // 10. ECOLE DE CONFIRMATION (RAPPORT TRIMESTRIEL COMPLET)
    'confirmation': ReportConfig(
      id: 'confirmation', 
      title: 'Rapport Trimestriel - École de Confirmation', 
      icon: Icons.school,
      kpis: [
        KPIConfig(label: 'Taux présence', target: 80, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Maîtrise Articles', target: 100, unit: '%', directiveRef: '§6.5.2'),
        KPIConfig(label: 'Implication Parents', target: 60, unit: '%', directiveRef: 'Leçon 1'),
      ],
      fields: [
        ReportField(key: 'h1', label: 'I. INFORMATIONS GÉNÉRALES', type: FieldType.header),
        ReportField(key: 'responsable', label: 'Responsable de catéchèse', type: FieldType.text, required: true),
        ReportField(key: 'cycle', label: 'Cycle de formation', type: FieldType.dropdown, options: ['1ère année', '2ème année', 'Cycle complet'], required: true),
        ReportField(key: 'effectif', label: 'Effectif total inscrit', type: FieldType.number, required: true),
        ReportField(key: 'presence_moy', label: 'Présence moyenne (%)', type: FieldType.number),
        ReportField(key: 'cahiers_dist', label: 'Cahiers "Moi aussi..." distribués', type: FieldType.text),
        
        ReportField(key: 'h2', label: 'II. PROGRESSION PÉDAGOGIQUE (35 LEÇONS)', type: FieldType.header),
        ReportField(key: 'bloc1', label: 'Bloc 1: Fondements de la foi (Leçons 1-6) - % Réalisé', type: FieldType.number, directiveRef: 'p.19'),
        ReportField(key: 'bloc2', label: 'Bloc 2: Vie chrétienne & Loi (Leçons 7-18) - % Réalisé', type: FieldType.number, directiveRef: 'p.50'),
        ReportField(key: 'bloc3', label: 'Bloc 3: Ministère & Sacrements (Leçons 19-24) - % Réalisé', type: FieldType.number, directiveRef: 'p.100'),
        ReportField(key: 'bloc4', label: 'Bloc 4: Avenir & Préparation (Leçons 25-29) - % Réalisé', type: FieldType.number, directiveRef: 'p.130'),
        
        ReportField(key: 'h3', label: 'III. MAÎTRISE DOCTRINALE & SACRAMENTELLE', type: FieldType.header),
        ReportField(key: 'maitrise_10_art', label: 'Mémorisation des 10 Articles de foi (%)', type: FieldType.number, required: true),
        ReportField(key: 'connaiss_sacrem', label: 'Connaissance des 3 sacrements (%)', type: FieldType.number),
        ReportField(key: 'notre_pere', label: 'Compréhension du "Notre Père" (%)', type: FieldType.number),
        ReportField(key: 'sens_voeu', label: 'Sens du vœu de confirmation (%)', type: FieldType.number),
        
        ReportField(key: 'h4', label: 'IV. DÉVELOPPEMENT DES VERTUS (Leçons 28a-28e)', type: FieldType.header),
        ReportField(key: 'evaluation_vertus', label: 'Évaluation collective des vertus (Foi, Amour, Fidélité)', type: FieldType.textarea, maxLines: 3),
        
        ReportField(key: 'h5', label: 'V. IMPLICATION DES PARENTS', type: FieldType.header),
        ReportField(key: 'reunions_parents', label: 'Nombre de réunions parents tenues', type: FieldType.number),
        ReportField(key: 'suivi_devoirs', label: 'Taux de suivi des devoirs à domicile (%)', type: FieldType.number),
        ReportField(key: 'difficultes_fam', label: 'Difficultés familiales signalées', type: FieldType.textarea, maxLines: 2),
        
        ReportField(key: 'h6', label: 'VI. PRÉPARATION PRATIQUE CÉRÉMONIE (Leçon 29)', type: FieldType.header),
        ReportField(key: 'check_ceremonie', label: 'Checklist Préparation', type: FieldType.checkbox, options: ['Lettre Patriarcale lue', 'Vœu maîtrisé collectivement', 'Tenues confirmées', 'Invitations distribuées']),
        ReportField(key: 'date_repetition', label: 'Date prévue répétition générale', type: FieldType.date),
        
        ReportField(key: 'h7', label: 'VII. DIFFICULTÉS & RECOMMANDATIONS', type: FieldType.header),
        ReportField(key: 'diff_pedago', label: 'Difficultés Pédagogiques', type: FieldType.textarea),
        ReportField(key: 'diff_orga', label: 'Difficultés Organisationnelles', type: FieldType.textarea),
        
        ReportField(key: 'h8', label: 'VIII. STATISTIQUES RÉCAPITULATIVES', type: FieldType.header),
        ReportField(key: 'prets_ceremonie', label: 'Nombre de confirmands prêts', type: FieldType.number),
        ReportField(key: 'objectifs_cycle', label: 'Objectif du cycle atteint', type: FieldType.dropdown, options: ['Oui', 'Partiellement', 'Non']),
      ],
      recommendations: [
        'Traiter les 35 leçons dans l\'ordre strict du manuel',
        'Vérifier la mémorisation des 10 articles (Leçon 26)',
        'Respecter la méthode dialogique : Dialogue, Cahier, Devoirs',
      ],
      libraryRefs: ['Manuel Catéchisme Prof', 'Directives §6.5', 'Vœu de Confirmation'],
    ),

    // 11. JEUNESSE
    'jeunesse': ReportConfig(
      id: 'jeunesse', title: 'Rapport Commission Jeunesse', icon: Icons.emoji_people,
      kpis: [KPIConfig(label: 'Jeunes actifs', target: 50, unit: '', directiveRef: '§7.9')],
      fields: [
        ReportField(key: 'total', label: 'Jeunes suivis', type: FieldType.number, required: true),
        ReportField(key: 'activites', label: 'Activités réalisées', type: FieldType.textarea, maxLines: 3),
      ],
      recommendations: ['Adapter accompagnement par âge (§7.9)'],
      libraryRefs: ['Directives §7.9', 'Guide Jeunesse'],
    ),

    // 12. ECONFI
    'econfi': ReportConfig(
      id: 'econfi', title: 'Rapport Financier (Econfi)', icon: Icons.account_balance,
      kpis: [KPIConfig(label: 'Concordance', target: 100, unit: '%', directiveRef: '§3.20.5')],
      fields: [
        ReportField(key: 'recettes_fc', label: 'Recettes FC', type: FieldType.number, required: true),
        ReportField(key: 'depenses_fc', label: 'Dépenses FC', type: FieldType.number, required: true),
        ReportField(key: 'justificatifs', label: 'Justificatifs joints', type: FieldType.checkbox, options: ['Oui']),
      ],
      recommendations: ['Double comptage obligatoire', 'Désintéressement strict (§3.20.5)'],
      libraryRefs: ['Directives §3.20.5', 'Guide Comptabilité'],
    ),

    // --- RAPPORTS MENSUELS UNIVERSELS POUR LES 12 COMMISSIONS ---

    'ecodim_mensuel': ReportConfig(
      id: 'ecodim_mensuel', title: 'Rapport Mensuel Ecodim', icon: Icons.child_care,
      kpis: [
        KPIConfig(label: 'Présence enfants', target: 85, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Présence moniteurs', target: 80, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.8'),
      ],
      fields: [
        ReportField(key: 'enfants_presents', label: 'Nombre d\'enfants présents', type: FieldType.number, required: true),
        ReportField(key: 'moniteurs_presents', label: 'Nombre de moniteurs présents', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'resolutions', label: 'Résolutions (Moi aussi je veux...)', type: FieldType.textarea, maxLines: 5),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Assurer une présence régulière des moniteurs', 'Encourager les enfants à prendre des résolutions'],
      libraryRefs: ['Manuel Catéchisme Prof', 'Directives Ecodim'],
    ),

    'econfi_mensuel': ReportConfig(
      id: 'econfi_mensuel', title: 'Rapport Mensuel Econfi', icon: Icons.school,
      kpis: [
        KPIConfig(label: 'Présence catéchumènes', target: 85, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Présence moniteurs', target: 80, unit: '%', directiveRef: '§7.8'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.8'),
      ],
      fields: [
        ReportField(key: 'catechumenes_presents', label: 'Nombre de catéchumènes présents', type: FieldType.number, required: true),
        ReportField(key: 'moniteurs_presents', label: 'Nombre de moniteurs présents', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'lecons_traitees', label: 'Leçons traitées', type: FieldType.textarea, maxLines: 3),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Suivre le programme des leçons', 'Préparer les catéchumènes à la confirmation'],
      libraryRefs: ['Manuel Catéchisme Prof', 'Directives Econfi'],
    ),

    'jeunesse_mensuel': ReportConfig(
      id: 'jeunesse_mensuel', title: 'Rapport Mensuel Jeunesse', icon: Icons.emoji_people,
      kpis: [
        KPIConfig(label: 'Présence jeunes', target: 70, unit: '%', directiveRef: '§7.9'),
        KPIConfig(label: 'Activités réalisées', target: 2, unit: '', directiveRef: '§7.9'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.9'),
      ],
      fields: [
        ReportField(key: 'jeunes_presents', label: 'Nombre de jeunes présents', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'themes_abordes', label: 'Thèmes abordés', type: FieldType.textarea, maxLines: 3),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Organiser des activités attractives', 'Encourager la participation active'],
      libraryRefs: ['Directives Jeunesse', 'Guide Jeunesse'],
    ),

    'papas_mensuel': ReportConfig(
      id: 'papas_mensuel', title: 'Rapport Mensuel Papas', icon: Icons.man,
      kpis: [
        KPIConfig(label: 'Présence papas', target: 60, unit: '%', directiveRef: '§7.11'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.11'),
      ],
      fields: [
        ReportField(key: 'papas_presents', label: 'Nombre de papas présents', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'reunions_tenues', label: 'Réunions tenues', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Renforcer la communion fraternelle', 'Soutenir les activités de la communauté'],
      libraryRefs: ['Directives Papas'],
    ),

    'mamans_mensuel': ReportConfig(
      id: 'mamans_mensuel', title: 'Rapport Mensuel Mamans', icon: Icons.woman,
      kpis: [
        KPIConfig(label: 'Présence mamans', target: 70, unit: '%', directiveRef: '§7.12'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.12'),
      ],
      fields: [
        ReportField(key: 'mamans_presentes', label: 'Nombre de mamans présentes', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'reunions_tenues', label: 'Réunions tenues', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Encourager l\'entraide', 'Participer à l\'entretien de l\'église'],
      libraryRefs: ['Directives Mamans'],
    ),

    'aines_mensuel': ReportConfig(
      id: 'aines_mensuel', title: 'Rapport Mensuel Aînés', icon: Icons.elderly,
      kpis: [
        KPIConfig(label: 'Aînés visités', target: 90, unit: '%', directiveRef: '§7.10'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.10'),
      ],
      fields: [
        ReportField(key: 'aines_visites', label: 'Nombre d\'aînés visités', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'besoins_signales', label: 'Besoins particuliers signalés', type: FieldType.textarea, maxLines: 3),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Assurer un suivi régulier', 'Apporter un soutien spirituel et moral'],
      libraryRefs: ['Directives Aînés'],
    ),

    'musique_mensuel': ReportConfig(
      id: 'musique_mensuel', title: 'Rapport Mensuel Musique', icon: Icons.music_note,
      kpis: [
        KPIConfig(label: 'Présence choristes', target: 80, unit: '%', directiveRef: '§8.1'),
        KPIConfig(label: 'Répétitions', target: 4, unit: '', directiveRef: '§8.1'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§8.1'),
      ],
      fields: [
        ReportField(key: 'choristes_presents', label: 'Nombre moyen de choristes', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'nouveaux_cantiques', label: 'Nouveaux cantiques appris', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Préparer les cantiques à l\'avance', 'Veiller à la qualité de l\'interprétation'],
      libraryRefs: ['Directives Musique'],
    ),

    'presse_mensuel': ReportConfig(
      id: 'presse_mensuel', title: 'Rapport Mensuel Presse & Sonorisation', icon: Icons.camera_alt,
      kpis: [
        KPIConfig(label: 'Couverture événements', target: 100, unit: '%', directiveRef: '§8.2'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§8.2'),
      ],
      fields: [
        ReportField(key: 'evenements_couverts', label: 'Événements couverts', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'etat_materiel', label: 'État du matériel', type: FieldType.dropdown, options: ['Bon', 'Moyen', 'À réparer']),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Vérifier le matériel régulièrement', 'Assurer une bonne communication'],
      libraryRefs: ['Directives Presse'],
    ),

    'arimathee_mensuel': ReportConfig(
      id: 'arimathee_mensuel', title: 'Rapport Mensuel Joseph d\'Arimathée', icon: Icons.volunteer_activism,
      kpis: [
        KPIConfig(label: 'Actions de soutien', target: 2, unit: '', directiveRef: '§7.13'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.13'),
      ],
      fields: [
        ReportField(key: 'actions_realisees', label: 'Actions réalisées', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'fonds_collectes', label: 'Fonds collectés (FC)', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Soutenir les projets de l\'église', 'Agir dans la discrétion'],
      libraryRefs: ['Directives Arimathée'],
    ),

    'securite_mensuel': ReportConfig(
      id: 'securite_mensuel', title: 'Rapport Mensuel Sécurité & Protocole', icon: Icons.security,
      kpis: [
        KPIConfig(label: 'Incidents', target: 0, unit: '', directiveRef: '§4.2'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§4.2'),
      ],
      fields: [
        ReportField(key: 'agents_presents', label: 'Nombre moyen d\'agents', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'incidents_majeurs', label: 'Incidents majeurs', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Maintenir l\'ordre et la discipline', 'Accueillir les fidèles avec courtoisie'],
      libraryRefs: ['Directives Sécurité'],
    ),

    'medicale_mensuel': ReportConfig(
      id: 'medicale_mensuel', title: 'Rapport Mensuel Commission Médicale', icon: Icons.local_hospital,
      kpis: [
        KPIConfig(label: 'Interventions', target: 5, unit: '', directiveRef: '§7.10'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§7.10'),
      ],
      fields: [
        ReportField(key: 'interventions', label: 'Nombre d\'interventions', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'cas_graves', label: 'Cas graves orientés', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Assurer les premiers soins', 'Orienter vers les structures adaptées'],
      libraryRefs: ['Directives Médicales'],
    ),

    'construction_mensuel': ReportConfig(
      id: 'construction_mensuel', title: 'Rapport Mensuel Construction', icon: Icons.build,
      kpis: [
        KPIConfig(label: 'Avancement travaux', target: 10, unit: '%', directiveRef: '§13.1'),
        KPIConfig(label: 'Taux présence Responsable', target: 95, unit: '%', directiveRef: '§13.1'),
      ],
      fields: [
        ReportField(key: 'chantiers_actifs', label: 'Chantiers actifs', type: FieldType.number, required: true),
        ReportField(key: 'taux_presence_responsable', label: 'Taux de présence du responsable (%)', type: FieldType.number, required: true),
        ReportField(key: 'etat_avancement', label: 'État d\'avancement global (%)', type: FieldType.number),
        ReportField(key: 'activites_mois', label: 'Activités du mois', type: FieldType.textarea, maxLines: 5),
      ],
      recommendations: ['Suivre les normes de construction', 'Veiller à la sécurité sur les chantiers'],
      libraryRefs: ['Directives Construction'],
    ),

    // 13. MEDICALE
    'medicale': ReportConfig(
      id: 'medicale', title: 'Rapport Commission Médicale', icon: Icons.local_hospital,
      kpis: [KPIConfig(label: 'Visites', target: 20, unit: '', directiveRef: '§7.10')],
      fields: [
        ReportField(key: 'visites', label: 'Visites effectuées', type: FieldType.number),
        ReportField(key: 'cas_urgents', label: 'Cas urgents signalés', type: FieldType.textarea, maxLines: 2),
      ],
      recommendations: ['Confidentialité médicale stricte (§3.20.6)'],
      libraryRefs: ['Directives §7.10'],
    ),

    // 14. AINES
    'aines': ReportConfig(
      id: 'aines', title: 'Rapport Commission Aînés (65+)', icon: Icons.elderly,
      kpis: [KPIConfig(label: 'Aînés visités', target: 90, unit: '%', directiveRef: '§7.10')],
      fields: [
        ReportField(key: 'total', label: 'Total recensés', type: FieldType.number, required: true),
        ReportField(key: 'visites', label: 'Visites effectuées', type: FieldType.number),
      ],
      recommendations: ['Prioriser visites régulières (§7.10)'],
      libraryRefs: ['Directives §7.10'],
    ),

    // 15. CONSTRUCTION
    'construction': ReportConfig(
      id: 'construction', title: 'Rapport Commission Construction', icon: Icons.build,
      kpis: [KPIConfig(label: 'Maintenance', target: 100, unit: '%', directiveRef: '§13.1')],
      fields: [
        ReportField(key: 'etat', label: 'État général', type: FieldType.dropdown, options: ['Bon', 'Moyen', 'À réparer']),
        ReportField(key: 'travaux', label: 'Travaux réalisés', type: FieldType.textarea),
      ],
      recommendations: ['Inspection trimestrielle obligatoire'],
      libraryRefs: ['Directives §13.1'],
    ),

    // 16. SECURITE
    'securite': ReportConfig(
      id: 'securite', title: 'Rapport Sécurité & Protocole', icon: Icons.security,
      kpis: [KPIConfig(label: 'Extincteurs', target: 100, unit: '%', directiveRef: '§4.2.1')],
      fields: [
        ReportField(key: 'extincteurs', label: 'Extincteurs OK', type: FieldType.checkbox, options: ['Oui']),
        ReportField(key: 'incidents', label: 'Incidents signalés', type: FieldType.textarea),
      ],
      recommendations: ['Contrôle mensuel extincteurs'],
      libraryRefs: ['Directives §4.2.1'],
    ),

    // 17. PRESSE
    'presse': ReportConfig(
      id: 'presse', title: 'Rapport Presse & Sonorisation', icon: Icons.camera_alt,
      kpis: [KPIConfig(label: 'Qualité sonore', target: 95, unit: '%', directiveRef: '§8')],
      fields: [
        ReportField(key: 'qualite', label: 'Qualité SD', type: FieldType.dropdown, options: ['Excellente', 'Bonne', 'Moyenne']),
        ReportField(key: 'besoins', label: 'Besoins équipement', type: FieldType.text),
      ],
      recommendations: ['Tester sonorisation 30min avant SD (§8)'],
      libraryRefs: ['Directives §8'],
    ),

    // 18. PAPAS
    'papas': ReportConfig(
      id: 'papas', title: 'Rapport Commission des Papas', icon: Icons.man,
      kpis: [KPIConfig(label: 'Papas actifs', target: 60, unit: '%', directiveRef: '§7.10')],
      fields: [
        ReportField(key: 'reunions', label: 'Réunions tenues', type: FieldType.number),
        ReportField(key: 'themes', label: 'Thèmes abordés', type: FieldType.text),
      ],
      recommendations: ['Aborder paternité & couple (§3.16.5)'],
      libraryRefs: ['Directives §7.10'],
    ),

    // 19. MAMANS
    'mamans': ReportConfig(
      id: 'mamans', title: 'Rapport Commission des Mamans', icon: Icons.woman,
      kpis: [KPIConfig(label: 'Mamans actives', target: 70, unit: '%', directiveRef: '§7.10')],
      fields: [
        ReportField(key: 'grossesses', label: 'Suivis grossesses', type: FieldType.number),
        ReportField(key: 'naissances', label: 'Naissances mois', type: FieldType.number),
      ],
      recommendations: ['Bénédiction prénatale systématique (§6.8.1)'],
      libraryRefs: ['Directives §6.8.1'],
    ),

    // 20. ARIMATHEE
    'arimathee': ReportConfig(
      id: 'arimathee', title: 'Rapport Joseph d\'Arimathée', icon: Icons.volunteer_activism,
      kpis: [KPIConfig(label: 'Services', target: 20, unit: '', directiveRef: '§9.4')],
      fields: [
        ReportField(key: 'effectif', label: 'Membres actifs', type: FieldType.number),
        ReportField(key: 'services', label: 'Services rendus', type: FieldType.textarea),
      ],
      recommendations: ['Planifier roulement hebdomadaire'],
      libraryRefs: ['Directives §9.4'],
    ),

    // 21. MUSIQUE
    'musique': ReportConfig(
      id: 'musique', title: 'Rapport Commission Musique', icon: Icons.music_note,
      kpis: [KPIConfig(label: 'Présence chorale', target: 80, unit: '%', directiveRef: '§8')],
      fields: [
        ReportField(key: 'cantiques', label: 'Cantiques travaillés', type: FieldType.text),
        ReportField(key: 'etat_instruments', label: 'État des instruments', type: FieldType.dropdown, options: ['Bon', 'Moyen', 'À réparer']),
      ],
      recommendations: ['Tester sonorisation 30min avant SD (§8)'],
      libraryRefs: ['Directives §8', 'Recueil Cantiques'],
    ),
  };
}

