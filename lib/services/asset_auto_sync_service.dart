import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/image_entity.dart';
import '../models/library_resource.dart';
import '../models/hierarchy_models.dart';

class AssetAutoSyncService {
  static Future<void> syncAssetsToHive() async {
    final String manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // 1. Scanner les ANNONCES (Images)
    final annoncesPaths = manifestMap.keys.where((path) => path.startsWith('assets/images/annonces/')).toList();
    final imageBox = Hive.box<ImageEntity>('image_entities');

    for (var path in annoncesPaths) {
      final fileName = path.split('/').last;
      if (!imageBox.containsKey(path)) {
        // Déterminer le niveau par le chemin du dossier
        EntityLevel level = EntityLevel.communaute;
        if (path.contains('/territoriale/')) level = EntityLevel.territoriale;
        else if (path.contains('/district/')) level = EntityLevel.district;

        await imageBox.put(path, ImageEntity(
          id: path,
          title: fileName.replaceAll('_', ' ').split('.').first,
          imagePath: fileName,
          level: level,
          responsibleName: "Système (Auto)",
          uploadDate: DateTime.now(),
          category: 'annonce',
        ));
      }
    }

    // 2. Scanner les PROGRAMMES (PDF/Textes)
    final libraryPaths = manifestMap.keys.where((path) => path.startsWith('assets/librairie/programmes/')).toList();
    final libraryBox = Hive.box<LibraryResource>('library_resources');

    for (var path in libraryPaths) {
      final fileName = path.split('/').last;
      if (!libraryBox.containsKey(path)) {
        await libraryBox.put(path, LibraryResource(
          id: path,
          title: fileName.replaceAll('_', ' ').split('.').first,
          resourcePath: fileName,
          category: LibraryCategory.programmes,
          type: path.endsWith('.pdf') ? ResourceType.pdf : ResourceType.text,
          uploadDate: DateTime.now(),
          description: "Programme importé automatiquement",
        ));
      }
    }
  }
}
