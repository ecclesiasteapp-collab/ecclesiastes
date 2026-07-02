import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

import 'package:ecclesiastes/services/logging_service.dart';
import '../config/organization_config.dart';
import '../utils/entite_types.dart';
import '../utils/id_generator.dart'; // Import du générateur d'ID

class HierarchySeedService {
  HierarchySeedService._();

  static Future<void> seedHierarchyAndCommissions() async {
    final entitesBox = await Hive.openBox<Map>('entites');
    final commissionsBox = await Hive.openBox<Map>('commissions_map');

    if (entitesBox.isNotEmpty && commissionsBox.isNotEmpty) {
          LoggingService.info('ℹ️ Hiérarchie déjà initialisée.');
      return;
    }

    // Charger le fichier JSON de configuration
    final String response = await rootBundle.loadString('assets/config/hierarchy_init.json');
    final data = json.decode(response);

    final Map<String, Map> entitesToPut = {};
    final Map<String, Map> commissionsToPut = {};

    // Seed de l'Église Internationale
    final internationalChurchData = data['international_church'];
    final String internationalId = internationalChurchData['id'];
    entitesToPut[internationalId] = {
      'id': internationalId,
      'nom': internationalChurchData['name'],
      'code': internationalChurchData['code'],
      'type': EntiteTypes.internationale,
      'niveau': 'internationale',
      'parent_id': null,
      'responsable_nom': 'Apôtre Patriarche à désigner',
      'responsable_role': 'apotrePatriarche',
    };

    // Seed des Églises Territoriales
    for (var territorialChurchData in data['territorial_churches']) {
      final String territorialId = territorialChurchData['id'];
      entitesToPut[territorialId] = {
        'id': territorialId,
        'nom': territorialChurchData['name'],
        'code': territorialChurchData['code'],
        'type': EntiteTypes.egliseTerritoriale,
        'niveau': 'territoriale',
        'parent_id': internationalId,
        'responsable_nom': 'Apôtre de district à désigner',
        'responsable_role': 'apotreDistrict',
      };

      // Seed des Champs Apostoliques
      for (var champData in territorialChurchData['apostolic_fields']) {
        final String champId = champData['id'];
        entitesToPut[champId] = {
          'id': champId,
          'nom': champData['name'],
          'code': champData['code'],
          'type': EntiteTypes.champApostolique,
          'niveau': 'champ',
          'parent_id': territorialId,
          'responsable_nom': champData['responsible'],
          'responsable_role': 'apotre',
          'nombre_districts': champData['districts']?.length ?? 0,
          'nombre_communautes': champData['districts']?.fold(0, (sum, item) => sum + (item['communities_count'] ?? 0)) ?? 0,
          'nombre_membres': 0, // À calculer ou à ajouter au JSON si nécessaire
          'nombre_ministres': 0, // À calculer ou à ajouter au JSON si nécessaire
        };

        // Seed des Districts
        for (var districtData in champData['districts']) {
          final String districtId = districtData['id'];
          final String districtName = districtData['name'];
          final String districtSeat = districtData['siege'];
          final int districtCommunitiesCount = districtData['communities_count'];

          entitesToPut[districtId] = {
            'id': districtId,
            'nom': districtName,
            'code': districtData['code'],
            'type': EntiteTypes.district,
            'parent_id': champId,
            'niveau': 'district',
            'responsable_nom': 'Ancien à désigner',
            'responsable_role': 'ancien',
            'nombre_communautes': districtCommunitiesCount,
            'nombre_membres': districtData['members_count'],
            'siege': districtSeat,
          };

          // Seed des Communautés et de leurs commissions
          for (var i = 1; i <= districtCommunitiesCount; i++) {
            final communityId = IdGenerator.generate(); // Utilisation du générateur d'ID
            final communityName = 'Communauté ${districtSeat.toUpperCase()} ${i.toString().padLeft(2, '0')}';

            entitesToPut[communityId] = {
              'id': communityId,
              'nom': communityName,
              'code': communityId,
              'type': EntiteTypes.communaute,
              'parent_id': districtId,
              'niveau': 'communaute',
              'responsable_nom': 'Prêtre à désigner',
              'responsable_role': 'pretre',
              'district_id': districtId,
              'district_nom': districtName,
              'champ_id': champId,
              'champ_nom': champData['name'],
            };

            for (final commission in OrganizationConfig.commissions) {
              final commissionId = IdGenerator.generate(); // Utilisation du générateur d'ID
              commissionsToPut[commissionId] = {
                'id': commissionId,
                'entite_id': communityId,
                'entite_nom': communityName,
                'entite_type': EntiteTypes.communaute,
                'district_id': districtId,
                'district_nom': districtName,
                'champ_id': champId,
                'champ_nom': champData['name'],
                'commission_code': commission.code,
                'commission_type': commission.type.name,
                'commission_nom': commission.name,
                'responsable_id': null,
                'responsable_nom': 'À désigner',
                'adjoint_id': null,
                'adjoint_nom': 'À désigner',
                'sous_commissions': commission.sousCommissions,
                'nombre_membres': 0,
                'statut': 'active',
              };
            }
          }
        }
      }
    }

    await entitesBox.putAll(entitesToPut);
    await commissionsBox.putAll(commissionsToPut);
        LoggingService.info('✅ Structure internationale déployée.');
  }
}

