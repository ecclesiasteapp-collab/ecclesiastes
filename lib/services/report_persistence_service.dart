import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/church_report.dart';

class ReportPersistenceService {
  static const String _boxName = 'reports_box';

  String get boxName => _boxName;

  Future<void> saveReport(ChurchReport report) async {
    final box = Hive.box<ChurchReport>(_boxName);
    await box.put(report.id, report);
  }

  Future<ChurchReport?> getReport(String id) async {
    final box = Hive.box<ChurchReport>(_boxName);
    return box.get(id);
  }

  Future<List<ChurchReport>> getAllReports() async {
    final box = Hive.box<ChurchReport>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteReport(String id) async {
    final box = Hive.box<ChurchReport>(_boxName);
    await box.delete(id);
  }

  Future<void> rejectReport(String reportId, String reason) async {
    debugPrint('Rapport $reportId rejeté: $reason');
  }
}

