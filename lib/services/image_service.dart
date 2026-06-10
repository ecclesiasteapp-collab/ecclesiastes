import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageService {
  /// Propose à l'utilisateur de prendre une photo ou d'en choisir une
  static Future<XFile?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie photos'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      return await picker.pickImage(source: source, imageQuality: 80);
    }
    return null;
  }
}
