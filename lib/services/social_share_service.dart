import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/hierarchy_models.dart';

class SocialShareService {
  /// Génère un message brandé pour le partage social au profit de l'application officielle
  Future<void> shareHierarchyBrandedContent(
    BuildContext context,
    String activityTitle,
    String entityName,
    EntityLevel level,
    CommissionType commission
  ) async {
    final String commissionName = _getCommissionLabel(commission);
    final String levelName = _getLevelLabel(level);

    final String message = """
📢 ÉGLISE NÉO-APOSTOLIQUE
✨ $activityTitle

📍 Lieu : $entityName ($levelName)
🎨 Organisé par : Commission $commissionName

📲 Suivez nos activités et restez connectés via notre application officielle Ecclésiaste !
🔗 Téléchargez l'application : https://ecclesiaste.rdc/download
👍 Suivez-nous sur Facebook : https://facebook.com/ecclesiaste.app
📺 Abonnez-vous sur YouTube : https://youtube.com/@ecclesiaste.app

#EcclesiasteApp #ENA #RDC #$levelName #$commissionName
""";

    await SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: 'Activité $entityName - Ecclésiaste',
      ),
    );
  }

  String _getCommissionLabel(CommissionType commission) {
    if (commission == CommissionType.none) return 'Générale';
    return commission.name.toUpperCase();
  }

  String _getLevelLabel(EntityLevel level) {
    return level.name.toUpperCase();
  }

  /// Partage d'un verset biblique
  Future<void> shareBibleVerse(BuildContext context, String book, int chapter, int verse, String text) async {
    final String message = "📖 LA SAINTE BIBLE \n✨ $book $chapter:$verse\n\n\"$text\"\n\n📲 Méditez la parole de Dieu sur l'application Ecclésiaste.";
    await SharePlus.instance.share(
      ShareParams(text: message),
    );
  }
}


