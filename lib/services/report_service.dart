import 'package:hive/hive.dart';
import '../models/church_report.dart';

class ReportService {
  static const String _boxName = 'church_reports';

  Box<ChurchReport> get _box {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<ChurchReport>(_boxName);
    }
    throw Exception('La boîte $_boxName doit être ouverte dans main.dart');
  }

  Future<int> getReportCount() async {
    return _box.length;
  }

  Future<List<ChurchReport>> getAllReports() async {
    return _box.values.toList();
  }

  Future<ChurchReport?> getReport(String id) async {
    return _box.get(id);
  }

  Future<void> saveReport(ChurchReport report) async {
    await _box.put(report.id, report);
  }

  Future<void> deleteReport(String id) async {
    await _box.delete(id);
  }

  // ✅ Méthodes manquantes pour report_provider.dart
  Future<ChurchReport> createReport(ChurchReport report) async {
    await _box.put(report.id, report);
    return report;
  }

  Future<ChurchReport> updateReport(ChurchReport report) async {
    await _box.put(report.id, report);
    return report;
  }

  void close() {
    // Rien à faire, Hive gère la fermeture
  }
}

