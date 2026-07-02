import 'package:intl/intl.dart';
import '../models/event_models.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class EventParserService {
  /// Parse un texte brut (type tableau copié) pour extraire des événements
  /// Format attendu (approximatif) : Date | Heure | Titre | Lieu | Officiant
  static List<Event> parseTextTable(String text) {
    final events = <Event>[];
    final lines = text.split('\n');

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      // Séparateur commun dans les tableaux copiés : Tabulation ou |
      final parts = line.split(RegExp(r'\t|\|'));

      if (parts.length >= 3) {
        try {
          final dateStr = parts[0].trim();
          final timeStr = parts.length > 1 ? parts[1].trim() : '10:00';
          final title = parts.length > 2 ? parts[2].trim() : 'Service Divin';
          final location = parts.length > 3 ? parts[3].trim() : '';
          final officiant = parts.length > 4 ? parts[4].trim() : '';

          // Tentative de parsing de la date (format dd/MM/yyyy ou yyyy-MM-dd)
          DateTime date;
          if (dateStr.contains('/')) {
            date = DateFormat('dd/MM/yyyy').parse(dateStr);
          } else {
            date = DateTime.parse(dateStr);
          }

          events.add(Event(
            id: const Uuid().v4(),
            title: title,
            description: 'Officiant: $officiant',
            dateTime: date,
            time: timeStr,
            location: location,
            type: EventType.serviceDivin,
            category: 'ECCLESIASTE',
            responsiblePerson: officiant,
          ));
        } catch (e, stack) {
          _logger.w('Ligne ignorée car malformée: $line',
              error: e, stackTrace: stack);
          continue;
        }
      }
    }
    return events;
  }
}

