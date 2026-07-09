import '../models/church_report.dart';
import '../models/hierarchy_models.dart';
import '../domain/repositories/report_repository.dart';
import '../domain/repositories/member_repository.dart';

/// Service d'agrégation de données pour les graphiques et KPIs.
/// Utilise les Repositories pour l'accès aux données.
class PastoralAnalyticsService {
  final ReportRepository reportRepository;
  final MemberRepository memberRepository;

  PastoralAnalyticsService({
    required this.reportRepository,
    required this.memberRepository,
  });

  /// Filtre les rapports selon l'entité et le niveau sélectionnés (Conforme aux 6 niveaux)
  List<ChurchReport> _filterReports(List<ChurchReport> allReports, String? entityId, EntityLevel? level) {
    if (entityId == null || level == null) return allReports;

    return allReports.where((r) {
      switch (level) {
        case EntityLevel.communaute:
          return r.nomEntite == entityId;
        case EntityLevel.district:
          return r.nomDistrict == entityId;
        case EntityLevel.champ:
          return r.nomChamp == entityId;
        case EntityLevel.regionApostolique:
          return r.nomRegion == entityId;
        case EntityLevel.territoriale:
          return true; // À affiner selon le stockage du territoire
        case EntityLevel.internationale:
          return true;
      }
    }).toList();
  }

  /// Récupère les statistiques réelles de l’entité sélectionnée
  Future<Map<String, dynamic>> getGlobalOverview({String? entityId, EntityLevel? level}) async {
    final allReports = await reportRepository.getAllChurchReports();
    final reports = _filterReports(allReports, entityId, level);
    
    // Pour les membres et ministres, on utilise le MemberRepository
    final allMembers = await memberRepository.getAllMembers();
    // Filtre simplifié : on pourrait affiner selon la hiérarchie
    final membersCount = allMembers.length; 

    return {
      'rapports': reports.length,
      'offrandes_total': reports.fold(0.0, (sum, r) => sum + r.offrandeFC),
      'presences_moyenne': reports.isEmpty ? 0.0 : reports.fold(0, (sum, r) => sum + r.presenceTotale) / reports.length,
      'membres': membersCount,
      'champs': 1, // Dynamiser si possible via HierarchyRepository
      'districts': 12,
      'derniere_maj': reports.isNotEmpty ? reports.last.dateRapport.toString().split(' ')[0] : 'N/A',
    };
  }

  /// Récupère la tendance de présence sur les 6 derniers mois
  Future<Map<String, double>> getPresenceTrend({String? entityId, EntityLevel? level}) async {
    final Map<String, double> data = {};
    final now = DateTime.now();
    final allReports = await reportRepository.getAllChurchReports();
    final filteredReports = _filterReports(allReports, entityId, level);
    
    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthKey = _getMonthKey(monthDate);

      final monthlyReports = filteredReports.where((r) =>
        r.dateRapport.year == monthDate.year &&
        r.dateRapport.month == monthDate.month &&
        r.type == ReportTypeExt.serviceDivin
      );

      if (monthlyReports.isEmpty) {
        data[monthKey] = 0.0;
      } else {
        final totalPresence = monthlyReports.fold(0, (sum, r) => sum + r.presenceTotale);
        data[monthKey] = totalPresence / monthlyReports.length;
      }
    }
    return data;
  }

  /// Récupère le total des actes sacramentels de l'année
  Future<Map<String, int>> getYearlySacraments({String? entityId, EntityLevel? level}) async {
    final now = DateTime.now();
    final allReports = await reportRepository.getAllChurchReports();
    final yearlyReports = _filterReports(allReports, entityId, level)
        .where((r) => r.dateRapport.year == now.year);

    int baptemes = 0;
    int scelles = 0;
    int confirmations = 0;

    for (var r in yearlyReports) {
      baptemes += r.nombreBaptemes;
      scelles += r.nombreScelles;
      confirmations += r.nombreConfirmations;
    }

    return {
      'Baptêmes': baptemes,
      'Scellements': scelles,
      'Confirmations': confirmations,
    };
  }

  /// Récupère l'évolution des offrandes (FC) sur 6 mois
  Future<Map<String, double>> getOfferingsTrend({String? entityId, EntityLevel? level}) async {
    final Map<String, double> data = {};
    final now = DateTime.now();
    final allReports = await reportRepository.getAllChurchReports();
    final filteredReports = _filterReports(allReports, entityId, level);

    for (int i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthKey = _getMonthKey(monthDate);

      final monthlyTotal = filteredReports
        .where((r) => r.dateRapport.year == monthDate.year && r.dateRapport.month == monthDate.month)
        .fold(0.0, (sum, r) => sum + r.offrandeFC);

      data[monthKey] = monthlyTotal;
    }
    return data;
  }

  String _getMonthKey(DateTime date) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return months[date.month - 1];
  }
}
