import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

class SocialShareService {
  final ScreenshotController screenshotController = ScreenshotController();

  // Méthode pour générer une image brandée et la partager
  Future<void> shareBrandedContent(BuildContext context, Widget contentWidget, String caption) async {
    // 1. Capturer le widget en image
    Uint8List imageBytes = await screenshotController.captureFromWidget(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            contentWidget,
            const SizedBox(height: 20),
            // LE FILIGRANE / BRANDING OBLIGATOIRE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF003366),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.church, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Ecclésiastes | @EcclesiastesOfficiel',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      pixelRatio: 3.0, // Haute qualité pour les réseaux sociaux
    );

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(imageBytes, mimeType: 'image/png', name: 'ecclesiastes_share.png')],
        text: '$caption\n\n📖 Découvrez Ecclésiastes...',
      ),
    );
  }
}
