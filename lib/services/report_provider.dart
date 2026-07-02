import '../models/church_report.dart';
import 'report_service.dart';

class ReportProvider {
  final ReportService _service = ReportService();

  Future<List<ChurchReport>> getAllReports() async {
    return _service.getAllReports();
  }

  Future<ChurchReport> createReport(ChurchReport report) async {
    return _service.createReport(report);
  }

  Future<ChurchReport> updateReport(ChurchReport report) async {
    return _service.updateReport(report);
  }

  Future<ChurchReport?> getReport(String id) async {
    return _service.getReport(id);
  }

  Future<void> deleteReport(String id) async {
    await _service.deleteReport(id);
  }

  void close() {
    _service.close();
  }
}

