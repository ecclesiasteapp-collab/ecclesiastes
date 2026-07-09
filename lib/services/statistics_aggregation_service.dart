import 'package:hive/hive.dart';
import '../models/hierarchy_models.dart';
import '../models/person_model.dart';
import '../models/church_report.dart';

class StatisticsAggregationService {
  static final StatisticsAggregationService instance = StatisticsAggregationService._internal();
  factory StatisticsAggregationService() => instance;
  StatisticsAggregationService._internal();

  /// Calcule les statistiques démographiques consolidées
  Future<Map<String, dynamic>> getDemographicStats(String entityId, EntityLevel level) async {
    final personsBox = await Hive.openBox<Person>('persons');
    final List<Person> targetPersons = personsBox.values.toList(); // Simplifié : filtrage réel requis

    int men = 0;
    int women = 0;
    int youth = 0;
    int children = 0;
    int adults = 0;
    int seniors = 0;

    final now = DateTime.now();

    for (var p in targetPersons) {
      if (p.isMale) {
        men++;
      } else {
        women++;
      }

      final age = now.year - p.birthDate.year;
      if (age < 14) {
        children++;
      } else if (age < 35) {
        youth++;
      } else if (age < 65) {
        adults++;
      } else {
        seniors++;
      }
    }

    return {
      'total': targetPersons.length,
      'gender': {'M': men, 'F': women},
      'age_brackets': {
        'Enfants': children,
        'Jeunes': youth,
        'Adultes': adults,
        'Aînés': seniors,
      }
    };
  }

  /// Calcule les tendances de présence (Santé Spirituelle)
  Future<Map<String, dynamic>> getAttendanceTrends(String entityId, EntityLevel level) async {
    final reportsBox = await Hive.openBox<ChurchReport>('church_reports');
    // Filtrage par entité et type Service Divin
    final reports = reportsBox.values
        .where((r) => r.type == ReportTypeExt.serviceDivin)
        .toList();
    
    reports.sort((a, b) => a.dateRapport.compareTo(b.dateRapport));

    final Map<String, int> data = {};
    for (var r in reports.take(10)) { // 10 derniers
      final dateStr = '${r.dateRapport.day}/${r.dateRapport.month}';
      data[dateStr] = r.presenceTotale ?? 0;
    }

    return {
      'history': data,
      'average': reports.isEmpty ? 0 : reports.map((r) => r.presenceTotale ?? 0).reduce((a, b) => a + b) / reports.length,
    };
  }
}
