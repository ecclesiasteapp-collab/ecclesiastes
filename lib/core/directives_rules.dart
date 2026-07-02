enum UserLevel { communaute, district, champ, territorial, apotre }

class DirectiveRules {
  // 🔒 Pouvoirs de nomination par niveau (Extrait des Directives §3.16 & §3.20)
  static const Map<UserLevel, List<String>> nominationPowers = {
    UserLevel.communaute: [
      'propose_nomination_service', // §3.13.2 - Moniteurs, Jeunesse
      'propose_commission_member'
    ],
    UserLevel.district: [
      'appoint_community_chief', // Mandatement §3.12
      'propose_minister_ordination', // §3.3.1
      'validate_local_changes'
    ],
    UserLevel.champ: [
      'appoint_district_chief', // Mandatement §3.12
      'approve_minister_proposals', 
      'validate_field_programs'
    ],
    UserLevel.territorial: [
      'validate_territorial_changes', 
      'coordinate_champs'
    ],
    UserLevel.apotre: [
      'ordain_minister', // §3.3.1 - À genoux, imposition des mains
      'mandate_chief', // §3.12 - À genoux, imposition des mains
      'nominate_assistant', // §3.13.1 - Debout, poignée de main
      'modify_hierarchy', 
      'validate_all'
    ],
  };

  //  Événements bloquants (aucun ajout local autorisé ces dates)
  static const List<String> blockedEventTypes = [
    'VISITE_APOSTOLIQUE', 
    'SERVICE_DIVIN_TERRITORIAL', 
    'FETE_APOSTOLIQUE'
  ];

  // ✅ Règle d'impact direct : Toute nomination doit suivre une chaîne de validation
  static String getValidationChain(UserLevel level) {
    switch (level) {
      case UserLevel.communaute: return 'Responsable de Commission → Conducteur (Validation) → District';
      case UserLevel.district: return 'Conducteur → District (Consolidation) → Champ';
      case UserLevel.champ: return 'Champ → Territorial (Présidence)';
      default: return 'Validation Apostolique (Direction de l\'Église)';
    }
  }

  // 🚫 Message d'erreur conforme aux Directives
  static String getBlockMessage(UserLevel level, String action) {
    return 'Conformément aux Directives Ministres (§3.16), le niveau \'$level\' n\'est pas autorisé à effectuer l\'action : \'$action\'. '
        'Veuillez soumettre une proposition au niveau supérieur pour examen pastoral.';
  }
}

