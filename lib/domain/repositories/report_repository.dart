import '../../models/church_report.dart';

/// Interface pour la gestion des rapports.
/// Gère les rapports structurés (ChurchReport) et les rapports dynamiques (Map).
abstract class ReportRepository {
  // --- RAPPORTS STRUCTURÉS (CHURCH REPORT) ---
  Future<List<ChurchReport>> getAllChurchReports();
  Future<ChurchReport?> getChurchReportById(String id);
  Future<void> saveChurchReport(ChurchReport report);
  Future<List<ChurchReport>> getReportsByStatus(ReportStatus status);

  // --- RAPPORTS DYNAMIQUES (OFFICIELS, MENSUELS) ---
  /// Enregistre un rapport sous forme de données brutes (Map).
  Future<void> saveDynamicReport({
    required String id,
    required String type,
    required Map<String, dynamic> data,
    required String entityId,
    required String rapporteurId,
    String status = 'soumis',
  });

  /// Récupère les rapports dynamiques filtrés par entité.
  Future<List<Map<String, dynamic>>> getDynamicReportsByEntity(String entityId);

  // --- OPÉRATIONS COMMUNES ---
  Future<void> validateReport(String id, String validatorId, {bool isChurchReport = true});
  Future<void> rejectReport(String id, String reason, {bool isChurchReport = true});
  Future<void> deleteReport(String id, {bool isChurchReport = true});
}
