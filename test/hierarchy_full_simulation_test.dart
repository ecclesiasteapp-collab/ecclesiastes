import 'package:flutter_test/flutter_test.dart';
import 'package:ecclesiaste/services/database_helper.dart';
import 'package:ecclesiaste/services/hive_governance_repository.dart';
import 'package:ecclesiaste/models/nomination_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() {
  group('Simulation Complète de Création de Hiérarchie', () {
    setUpAll(() async {
      Hive.init(Directory.systemTemp.path);
      // On s'assure que les boîtes sont propres
      await Hive.openBox<Map>('entites');
      // Pour ce test, on va simuler les nominations sans passer par Hive 
      // car l'enregistrement des adaptateurs est complexe en test isolé
    });

    test('Création en cascade : Territoriale -> Région -> Champ -> District -> Communauté', () async {
      final db = DatabaseHelper.instance;
      const uuid = Uuid();

      print('--- Début de la Simulation ---');

      // 1. Création de l\'Église Territoriale
      final terrId = 'terr_rdc_centre';
      await db.insertEntite(id: terrId, nom: 'RDC Centre', type: 'EGLISE_TERRITORIALE', parentId: 'international_root');
      print('✅ Église Territoriale créée : RDC Centre');

      // 2. Création de la Région Apostolique
      final regId = 'reg_kasai';
      await db.insertEntite(id: regId, nom: 'Région Kasaï', type: 'REGION_APOSTOLIQUE', parentId: terrId);
      print('✅ Région Apostolique créée : Région Kasaï');

      // 3. Création du Champ Apostolique
      final champId = 'champ_kananga';
      await db.insertEntite(id: champId, nom: 'Champ Kananga', type: 'CHAMP_APOSTOLIQUE', parentId: regId);
      print('✅ Champ Apostolique créé : Champ Kananga');

      // 4. Création du District
      final distId = 'dist_katoka';
      await db.insertEntite(id: distId, nom: 'District Katoka', type: 'DISTRICT', parentId: champId);
      print('✅ District créé : District Katoka');

      // 5. Création de la Communauté
      final comId = 'com_st_luc';
      await db.insertEntite(id: comId, nom: 'Communauté St Luc', type: 'COMMUNAUTE', parentId: distId);
      print('✅ Communauté créée : Communauté St Luc');

      // VERIFICATIONS FINALES
      final chaine = await db.getChaineAncestres(comId);
      
      print('\n--- Vérification de la lignée (Bottom-Up) ---');
      for (var ent in chaine) {
        print('${ent['type']} : ${ent['nom']}');
      }

      expect(chaine.length, 6); // Com + Dist + Champ + Reg + Terr + Internat
      expect(chaine.last['id'], 'international_root');
      expect(chaine.first['nom'], 'Communauté St Luc');
      
      print('\n--- Simulation Réussie : Structure 100% Cohérente ---');
    });
  });
}
