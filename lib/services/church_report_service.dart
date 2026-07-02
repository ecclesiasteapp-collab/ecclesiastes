import 'package:hive/hive.dart';
import '../models/church_report.dart';

class ChurchReportService {
  static const String boxName = 'church_reports';

  static Box<ChurchReport> get _box => Hive.box<ChurchReport>(boxName);

  static List<ChurchReport> getAll() {
    return _box.values.toList()..sort((a, b) => b.dateRapport.compareTo(a.dateRapport));
  }

  static Future<void> save(ChurchReport report) async {
    await _box.put(report.id, report);
  }

  static Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

