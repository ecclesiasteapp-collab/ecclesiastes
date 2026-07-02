import 'package:hive/hive.dart';
import '../models/church_report.dart';
import '../models/hierarchy_models.dart';
import '../config/kso_districts_config.dart';

class PastoralAnalyticsService {
  Box<ChurchReport> get _reportBox => Hive.box<ChurchReport>('church_reports');

  /// Filtre les rapports selon l'entité et le niveau sélectionnés
  Iterable<ChurchReport> _getFilteredReports(String? entityId, EntityLevel? level) {
    final allReports = _reportBox.values;
    if (entityId == null || level == null) return allReports;

    return allReports.where((r) {
      switch (level) {
        case EntityLevel.communaute:
          return r.nomEntite == entityId;
        case EntityLevel.district:
          return r.nomDistrict == entityId;
        case EntityLevel.champ:
          return r.nomChamp == entityId;
        default:
          return true;
      }
    });
  }

  /// Récupère les statistiques réelles de l’entité sélectionnée
  Map<String, dynamic> getGlobalOverview({String? entityId, EntityLevel? level}) {
    final reports = _getFilteredReports(entityId, level);
    
    // Fallback sur les constantes si aucun rapport n'est encore saisi pour KSO
    if (reports.isEmpty && (entityId == null || entityId == 'kso')) {
      return {
        'champs': 1,
        'districts': KSODistrictsConfig.totalDistricts,
        'communautes': KSODistrictsConfig.totalCommunautes,
        'membres': KSODistrictsConfig.totalMembres,
        'ministres': KSODistrictsConfig.totalMinistres,
        'derniere_maj': KSODistrictsConfig.dateTableau,
      };
    }

    return {
      'rapports': reports.length,
      'offrandes_total': reports.fold(0.0, (sum, r) => sum + r.offrandeFC),
      'presences_moyenne': reports.isEmpty ? 0 : reports.fold(0, (sum, r) => sum + r.presenceTotale) / reports.length,
      'derniere_maj': reports.isNotEmpty ? reports.last.dateRapport.toString().split(' ')[0] : 'N/A',
    };
  }


  /// Récupère la tendance de présence sur les 6 derniers mois pour une entité
  Map<String, double> getPresenceTrend({String? entityId, EntityLevel? level}) {
    final Map<String, double> data = {};
    final now = DateTime.now();
    final filteredReports = _getFilteredReports(entityId, level);
    
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = _getMonthKey(month);

      final monthlyReports = filteredReports.where((r) =>
        r.dateRapport.year == month.year &&
        r.dateRapport.month == month.month &&
        r.type == ReportTypeExt.serviceDivin
      );

      if (monthlyReports.isEmpty) {
        data[monthKey] = 0;
      } else {
        final totalPresence = monthlyReports.fold(0, (sum, r) => sum + r.presenceTotale);
        data[monthKey] = totalPresence / monthlyReports.length; // Moyenne par service
      }
    }
    return data;
  }

  /// Récupère le total des actes sacramentels de l'année pour une entité
  Map<String, int> getYearlySacraments({String? entityId, EntityLevel? level}) {
    final now = DateTime.now();
    final yearlyReports = _getFilteredReports(entityId, level)
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

  /// Récupère l'évolution des offrandes (FC) sur 6 mois pour une entité
  Map<String, double> getOfferingsTrend({String? entityId, EntityLevel? level}) {
    final Map<String, double> data = {};
    final now = DateTime.now();
    final filteredReports = _getFilteredReports(entityId, level);

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthKey = _getMonthKey(month);

      final monthlyTotal = filteredReports
        .where((r) => r.dateRapport.year == month.year && r.dateRapport.month == month.month)
        .fold(0.0, (sum, r) => sum + r.offrandeFC);

      data[monthKey] = monthlyTotal;
    }
    return data;
  }

  String _getMonthKey(DateTime date) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];
    return months[date.month - 1];
  }

  /// Récupère le statut sacramentel pour une entité donnée
  static Map<String, int> getSacramentalStatus(String entityName, EntityLevel level) {
    // Dans une version réelle, on filtrerait la Box Hive MemberProfile
    return {
      'Jeunes (14+) baptisés non scellés': 12,
      'Besoins pastoraux (Incohérences)': 5,
      'Baptisés non scellés': 24,
      'Membres nés NAC': 150,
      'Convertis': 30,
    };
  }
}

