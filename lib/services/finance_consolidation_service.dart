import 'package:hive/hive.dart';
import '../models/hierarchy_models.dart';
import 'database_helper.dart';

class FinanceConsolidationService {
  static final FinanceConsolidationService instance = FinanceConsolidationService._internal();
  factory FinanceConsolidationService() => instance;
  FinanceConsolidationService._internal();

  /// Récupère le total des offrandes consolidées pour une entité donnée
  Future<Map<String, double>> getConsolidatedTotals(String entityId, EntityLevel level) async {
    final db = DatabaseHelper.instance;
    final List<String> communauteIds = [];

    // 1. Identifier toutes les communautés sous cette entité
    if (level == EntityLevel.communaute) {
      communauteIds.add(entityId);
    } else {
      final allSubComms = await _getAllChildCommunities(entityId, level);
      communauteIds.addAll(allSubComms);
    }

    // 2. Sommer les finances de ces communautés
    double totalFc = 0;
    double totalUsd = 0;

    final financesBox = await Hive.openBox<Map>('finances');
    for (var f in financesBox.values) {
      if (communauteIds.contains(f['entite_id'])) {
        final double montant = (f['montant'] as num).toDouble();
        if (f['devise'] == 'USD') {
          totalUsd += montant;
        } else {
          totalFc += montant;
        }
      }
    }

    return {
      'FC': totalFc,
      'USD': totalUsd,
    };
  }

  Future<List<String>> _getAllChildCommunities(String entityId, EntityLevel level) async {
    final db = DatabaseHelper.instance;
    List<String> ids = [];

    if (level == EntityLevel.district) {
      final comms = await db.getCommunautesByDistrict(entityId);
      ids.addAll(comms.map((c) => c['id'].toString()));
    } else if (level == EntityLevel.champ) {
      final districts = await db.getDistricts(champId: entityId);
      for (var d in districts) {
        final comms = await db.getCommunautesByDistrict(d['id']);
        ids.addAll(comms.map((c) => c['id'].toString()));
      }
    }
    // ... Étendre pour Région, Territoriale, etc.
    
    return ids;
  }
}
