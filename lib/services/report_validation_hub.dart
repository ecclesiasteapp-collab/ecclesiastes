import 'package:hive/hive.dart';
import '../models/report_model.dart';

class ReportValidationHub {
  static const String boxName = 'reports_box';

  static Future<void> submitReport(ReportModel report) async {
    final box = await Hive.openBox<ReportModel>(boxName);
    report.status = 'soumis';
    await box.put(report.id, report);
  }

  static Future<void> validateReport(String reportId, String validatorName) async {
    final box = await Hive.openBox<ReportModel>(boxName);
    final report = box.get(reportId);
    if (report != null) {
      report.status = 'valide';
      // Logique simplifiée pour l'exemple
      await report.save();
    }
  }

  static List<ReportModel> getPendingReports() {
    final box = Hive.box<ReportModel>(boxName);
    return box.values.where((r) => r.status == 'soumis').toList();
  }
}

