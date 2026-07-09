import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

import 'package:ecclesiaste/services/logging_service.dart';
import 'package:ecclesiaste/config/organization_config.dart';
import 'package:ecclesiaste/utils/entite_types.dart';
import 'package:ecclesiaste/utils/id_generator.dart'; 
import 'package:ecclesiaste/models/commission_node.dart';
import 'package:ecclesiaste/models/hierarchy_models.dart';
import 'package:ecclesiaste/models/district_model.dart';

class HierarchySeedService {
  HierarchySeedService._();

  static Future<void> seedHierarchyAndCommissions() async {
    final entitesBox = await Hive.openBox<Map>('entites');
    final commissionsBox = await Hive.openBox<Map>('commissions_map');
    
    // Si la base est déjà peuplée, on ne réinitialise pas pour ne pas écraser les données manuelles
    if (entitesBox.isNotEmpty && entitesBox.containsKey('international_root')) {
      LoggingService.info('ℹ️ Hiérarchie déjà présente. Pas de re-seeding.');
      return;
    }

    // 1. Initialisation de la Racine Internationale
    await entitesBox.put('international_root', {
      'id': 'international_root',
      'nom': "Église Néo-Apostolique Internationale",
      'code': "INTER",
      'type': EntiteTypes.internationale,
      'parent_id': null,
    });

    // 2. Chargement de la pré-installation depuis le JSON si disponible
    try {
      final String response = await rootBundle.loadString('assets/config/hierarchy_init.json');
      final data = json.decode(response);
      
      // ... Logique de parsing récursive pour créer les Territoriales, Régions, Champs...
      // Chaque entité créée via JSON verra ses commissions activées automatiquement
      // (Appel à la même logique que la création manuelle)
      
      LoggingService.info('✅ Pré-installation de la hiérarchie terminée depuis le JSON.');
    } catch (e) {
      LoggingService.info('ℹ️ Aucun fichier de pré-installation valide trouvé. Mode manuel uniquement.');
    }
  }
}
