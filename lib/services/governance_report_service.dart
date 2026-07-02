import 'package:ecclesiastes/services/database_helper.dart';
import 'package:ecclesiastes/services/attachment_storage_service.dart';
import 'package:hive/hive.dart';

class GovernanceReportService {
  GovernanceReportService._();

  /// Génère un rapport complet sur l'état de la gouvernance et de la sécurité
  static Future<Map<String, dynamic>> generateWeeklyReport() async {
    final db = DatabaseHelper.instance;
    
    final results = await Future.wait([
      db.getGovernanceStatus(),
      db.getSecurityStats(),
      db.getActiveDelegationsCount(),
      db.getTotalUsers(),
      db.getTotalEntities(),
      AttachmentStorageService.getTotalAttachmentSizeInMB(),
    ]);

    final report = {
      'id': 'rep_${DateTime.now().millisecondsSinceEpoch}',
      'date_generation': DateTime.now().toIso8601String(),
      'type': 'hebdomadaire',
      'donnees': {
        'governance': results[0],
        'security': results[1],
        'delegations': results[2],
        'total_users': results[3],
        'total_entities': results[4],
        'storage_mb': results[5],
      },
      'alertes': _generateAlerts(results[0] as Map<String, int>, results[1] as Map<String, int>),
    };

    // Sauvegarde dans Hive
    final box = await Hive.openBox<Map>('governance_reports');
    await box.put(report['id'], report);
    
    return report;
  }

  static List<String> _generateAlerts(Map<String, int> gov, Map<String, int> sec) {
    final alerts = <String>[];
    
    final vacants = gov['Vacants'] ?? 0;
    if (vacants > 0) {
      alerts.add('Attention : $vacants entités n\'ont pas de responsable nommé.');
    }

    final interims = gov['Intérims'] ?? 0;
    if (interims > 5) {
      alerts.add('Alerte : Nombre élevé d\'intérims ($interims). Envisager des nominations définitives.');
    }

    final suspendus = sec['Suspendus'] ?? 0;
    if (suspendus > 0) {
      alerts.add('Sécurité : $suspendus comptes sont actuellement suspendus.');
    }

    return alerts;
  }

  static Future<List<Map<String, dynamic>>> getReportsHistory() async {
    final box = await Hive.openBox<Map>('governance_reports');
    return box.values.map((r) => Map<String, dynamic>.from(r)).toList()
      ..sort((a, b) => b['date_generation'].compareTo(a['date_generation']));
  }
}

