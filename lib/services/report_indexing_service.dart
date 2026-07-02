import 'package:flutter/foundation.dart';
import '../models/church_report.dart';

class ReportIndexingService {
  Future<void> indexReport(ChurchReport report) async {
    debugPrint('Indexation du rapport ${report.id}');
  }

  Future<void> reindexAllReports(List<ChurchReport> reports) async {
    for (final report in reports) {
      await indexReport(report);
    }
  }

  Future<int> getPendingCount() async {
    return 0; // TODO: Implémenter
  }
}

