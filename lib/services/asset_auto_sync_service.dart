import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/image_entity.dart';
import '../models/library_resource.dart';
import '../models/hierarchy_models.dart';
import 'database_service.dart';

class AssetAutoSyncService {
  static Future<void> syncAssetsToHive() async {
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> allAssetPaths = manifest.listAssets();

      if (allAssetPaths.isEmpty) {
        debugPrint('ℹ️ No assets found in manifest.');
        return;
      }

      // 1. Scanner les ANNONCES (Images)
      final allAnnonces = allAssetPaths.where((path) => path.contains('/annonces/')).toList();

      final imageBox = await DatabaseService.openBox<ImageEntity>(
        DatabaseService.imageEntitiesBoxName,
      );

      if (allAnnonces.isNotEmpty) {
        for (var path in allAnnonces) {
          final fileName = path.split('/').last;
          if (fileName == 'README.md' || fileName.startsWith('.')) continue;

          if (!imageBox.containsKey(path)) {
            EntityLevel level = EntityLevel.communaute;

            if (path.contains('/internationale/')) {
              level = EntityLevel.internationale;
            } else if (path.contains('/territoriales/')) {
              level = EntityLevel.territoriale;
            } else if (path.contains('/champs/')) {
              level = EntityLevel.champ;
            } else if (path.contains('/districts/')) {
              level = EntityLevel.district;
            }

            await imageBox.put(path, ImageEntity(
              id: path,
              title: fileName.replaceAll('_', ' ').split('.').first,
              imagePath: path,
              level: level,
              responsibleName: 'Système (Auto)',
              uploadDate: DateTime.now(),
              category: 'annonce',
            ));
          }
        }
      }

      // 2. Scanner les DOCUMENTS (PDF/Textes)
      final allDocuments = allAssetPaths.where((path) => path.contains('/documents/')).toList();
      final libraryBox = await DatabaseService.openBox<LibraryResource>(
        DatabaseService.libraryResourcesBoxName,
      );

      if (allDocuments.isNotEmpty) {
        for (var path in allDocuments) {
          final fileName = path.split('/').last;
          if (fileName == 'README.md' || fileName.startsWith('.')) continue;

          if (!libraryBox.containsKey(path)) {
            LibraryCategory category = LibraryCategory.visionEglise;
            if (path.contains('/membre/')) {
              category = LibraryCategory.catechisme;
            } else if (path.contains('/ministre/')) {
              category = LibraryCategory.liturgie;
            } else if (path.contains('/commissions/')) {
              category = LibraryCategory.visionEglise;
            } else if (path.contains('/entites/')) {
              category = LibraryCategory.visionEglise;
            }

            await libraryBox.put(path, LibraryResource(
              id: path,
              title: fileName.replaceAll('_', ' ').split('.').first,
              resourcePath: path,
              category: category,
              type: path.endsWith('.pdf') ? ResourceType.pdf : ResourceType.text,
              uploadDate: DateTime.now(),
              description: 'Document importé automatiquement',
            ));
          }
        }
      }
    } catch (e) {
      debugPrint('Warning: Asset sync skipped: $e');
    }
  }
}

