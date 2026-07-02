import 'package:ecclesiastes/services/logging_service.dart';
import 'package:hive/hive.dart';
import 'hierarchy_seed_service.dart'; // Import du nouveau service de seeding
import '../config/kso_architecture_config.dart';

class DatabaseInitializer {
  static Future<void> seedInitialHierarchy() async {
    final entitesBox = await Hive.openBox<Map>('entites'); // Vérifier la box des entités

    if (entitesBox.isNotEmpty) {
      LoggingService.info('ℹ️ Hiérarchie déjà initialisée.');
      return;
    }

    LoggingService.info('🌱 Initialisation de la hiérarchie Ecclésiaste...');

    await HierarchySeedService.seedHierarchyAndCommissions(); // Appel du nouveau service
    LoggingService.info('✅ Structure internationale déployée.');
    await KsoArchitectureConfig.initializeCounts(); // Initialiser les totaux après le seeding
  }
}

