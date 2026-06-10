class PedagogyRules {
  /// Règles d'or extraites des "Indications méthodologiques" du Manuel du Maître
  static const List<String> catechisteGoldenRules = [
    "⚠️ NE PAS LIRE LES HISTOIRES : Il faut les RACONTER de manière vivante.",
    "⚠️ MÉTHODE DIALOGIQUE : Posez des questions, écoutez toutes les réponses avant de résumer.",
    "✅ OBJECTIF PÉDAGOGIQUE : La priorité n'est pas le sujet, mais la conviction personnelle de l'élève.",
    "✅ RÉSOLUTION 'MOI AUSSI...' : Chaque leçon doit aboutir à cette résolution personnelle.",
  ];

  /// Règles pour les moniteurs Ecodim
  static const List<String> ecdimGoldenRules = [
    "⚠️ CAHIER 'MOI AUSSI...' : Il doit être utilisé à chaque séance.",
    "✅ APPLICATION 'VISEZ LE BUT' : Intégrer l'activité avec ballon quand elle est au programme.",
    "✅ DIALOGUE FAMILIAL : Encourager les enfants à partager la leçon avec leurs parents.",
  ];

  static bool isBalloonActivity(String lessonTitle) {
    return lessonTitle.toLowerCase().contains("ballon") || 
           lessonTitle.toLowerCase().contains("visez le but");
  }
}
