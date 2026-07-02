import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonSchemaLoader {
  static Map<String, dynamic>? _cachedSchemas;

  // Charge tous les schémas depuis le fichier JSON
  static Future<Map<String, dynamic>> loadAllSchemas() async {
    if (_cachedSchemas != null) return _cachedSchemas!;

    final jsonString = await rootBundle.loadString('assets/schemas/reports_schema.json');
    _cachedSchemas = json.decode(jsonString) as Map<String, dynamic>;
    return _cachedSchemas!;
  }

  // Récupère le schéma d'un rapport spécifique par son ID
  static Future<Map<String, dynamic>> getReportSchema(String reportId) async {
    final allSchemas = await loadAllSchemas();
    final reports = allSchemas['reports'] as List<dynamic>;
    
    for (var report in reports) {
      if (report['id'] == reportId) {
        return report as Map<String, dynamic>;
      }
    }
    throw Exception('Schéma non trouvé pour le rapport: $reportId');
  }
}

