import 'package:hive/hive.dart';
import '../domain/repositories/report_repository.dart';
import '../models/church_report.dart';
import 'database_service.dart';

/// Implémentation de [ReportRepository] utilisant Hive.
class HiveReportRepository implements ReportRepository {
  static const String _dynamicBoxName = 'rapports';

  @override
  Future<List<ChurchReport>> getAllChurchReports() async {
    final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
    final list = box.values.toList();
    list.sort((a, b) => b.dateRapport.compareTo(a.dateRapport));
    return list;
  }

  @override
  Future<ChurchReport?> getChurchReportById(String id) async {
    final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
    return box.get(id);
  }

  @override
  Future<void> saveChurchReport(ChurchReport report) async {
    final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
    await box.put(report.id, report);
  }

  @override
  Future<List<ChurchReport>> getReportsByStatus(ReportStatus status) async {
    final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
    return box.values.where((r) => r.statut == status).toList();
  }

  @override
  Future<void> saveDynamicReport({
    required String id,
    required String type,
    required Map<String, dynamic> data,
    required String entityId,
    required String rapporteurId,
    String status = 'soumis',
  }) async {
    final box = await DatabaseService.openBox<Map>(_dynamicBoxName);
    await box.put(id, {
      'id': id,
      'type': type,
      'entite_id': entityId,
      'rapporteur_id': rapporteurId,
      'date_creation': DateTime.now().toIso8601String(),
      'data': data,
      'status': status,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getDynamicReportsByEntity(String entityId) async {
    final box = await DatabaseService.openBox<Map>(_dynamicBoxName);
    return box.values
        .where((m) => m['entite_id'] == entityId)
        .map((m) => Map<String, dynamic>.from(m))
        .toList()
      ..sort((a, b) => (b['date_creation'] ?? '').compareTo(a['date_creation'] ?? ''));
  }

  @override
  Future<void> validateReport(String id, String validatorId, {bool isChurchReport = true}) async {
    if (isChurchReport) {
      final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
      final report = box.get(id);
      if (report != null) {
        report.statut = ReportStatus.valide;
        report.validateur = validatorId;
        report.dateValidation = DateTime.now();
        await box.put(id, report);
      }
    } else {
      final box = await DatabaseService.openBox<Map>(_dynamicBoxName);
      final report = box.get(id);
      if (report != null) {
        final updated = Map<String, dynamic>.from(report);
        updated['status'] = 'valide';
        updated['validation_date'] = DateTime.now().toIso8601String();
        updated['validator_id'] = validatorId;
        await box.put(id, updated);
      }
    }
  }

  @override
  Future<void> rejectReport(String id, String reason, {bool isChurchReport = true}) async {
    if (isChurchReport) {
      final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
      final report = box.get(id);
      if (report != null) {
        report.statut = ReportStatus.rejete;
        report.motifRejet = reason;
        await box.put(id, report);
      }
    } else {
      final box = await DatabaseService.openBox<Map>(_dynamicBoxName);
      final report = box.get(id);
      if (report != null) {
        final updated = Map<String, dynamic>.from(report);
        updated['status'] = 'rejete';
        updated['rejection_reason'] = reason;
        await box.put(id, updated);
      }
    }
  }

  @override
  Future<void> deleteReport(String id, {bool isChurchReport = true}) async {
    if (isChurchReport) {
      final box = await DatabaseService.openBox<ChurchReport>(DatabaseService.churchReportsBoxName);
      await box.delete(id);
    } else {
      final box = await DatabaseService.openBox<Map>(_dynamicBoxName);
      await box.delete(id);
    }
  }
}
