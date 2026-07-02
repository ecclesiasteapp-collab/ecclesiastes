import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class ProfileService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      debugPrint('Erreur de sélection d\'image: $e');
      return null;
    }
  }

  Future<void> saveProfilePhoto(XFile file, String userId) async {
    final box = await Hive.openBox('profile_metadata');
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      await box.put('photo_$userId', bytes);
    } else {
      await box.put('photo_path_$userId', file.path);
    }
  }

  Future<dynamic> getProfilePhoto(String userId) async {
    final box = await Hive.openBox('profile_metadata');
    if (kIsWeb) {
      return box.get('photo_$userId');
    } else {
      return box.get('photo_path_$userId');
    }
  }
}

