import 'package:intl/intl.dart';
import '../models/isar/event.dart';
import 'package:uuid/uuid.dart';

class EventParserService {
  /// Parse un texte brut (type tableau copié) pour extraire des événements
  /// Format attendu (approximatif) : Date | Heure | Titre | Lieu | Officiant
  static List<Event> parseTextTable(String text) {
    List<Event> events = [];
    final lines = text.split('\n');
    
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Séparateur commun dans les tableaux copiés : Tabulation ou |
      final parts = line.split(RegExp(r'\t|\|'));
      
      if (parts.length >= 3) {
        try {
          String dateStr = parts[0].trim();
          String timeStr = parts.length > 1 ? parts[1].trim() : "10:00";
          String title = parts.length > 2 ? parts[2].trim() : "Service Divin";
          String location = parts.length > 3 ? parts[3].trim() : "";
          String officiant = parts.length > 4 ? parts[4].trim() : "";

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
            description: "Officiant: $officiant",
            dateTime: date,
            time: timeStr,
            location: location,
            type: EventType.serviceDivin,
            category: 'ECCLESIASTE',
            responsiblePerson: officiant,
          ));
        } catch (e) {
          // Ligne non valide, on ignore
          continue;
        }
      }
    }
    return events;
  }
}
