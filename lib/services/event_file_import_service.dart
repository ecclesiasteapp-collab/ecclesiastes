import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../models/event_models.dart';

class EventFileImportService {
  /// Importe les événements à partir d'un fichier CSV
  /// Format attendu : Date (DD/MM/YYYY) | Heure (HH:MM) | Titre | Lieu | Officiant
  static Future<List<Event>> importFromCSVBytes(Uint8List bytes) async {
    try {
      final content = utf8.decode(bytes, allowMalformed: true);
      final rows = _parseCsvContent(content);

      final List<Event> events = [];

      // Ignorer la première ligne si c'est un en-tête
      final startIndex = (rows.isNotEmpty && _isHeader(rows[0])) ? 1 : 0;

      for (int i = startIndex; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 5) continue;

        try {
          final event = _parseEventRow(row);
          if (event != null) {
            events.add(event);
          }
        } catch (e) {
          debugPrint('Erreur lors du parsing de la ligne $i: $e');
          continue;
        }
      }

      return events;
    } catch (e) {
      debugPrint('Erreur lors de l\'importation CSV: $e');
      rethrow;
    }
  }

  /// Importe les événements à partir d'un fichier Excel (XLSX)
  static Future<List<Event>> importFromExcelBytes(Uint8List bytes) async {
    // Note: l'import Excel nécessitait des dépendances externes (ex: `excel`) qui ne
    // sont pas déclarées dans `pubspec.yaml`. On garde la signature pour l'UI,
    // mais on désactive proprement la fonctionnalité.
    throw UnsupportedError(
      'Import Excel non disponible: support XLSX/XLS désactivé (dépendance manquante).',
    );
  }

  /// Importe les événements à partir d'un fichier ICS (iCalendar)
  static Future<List<Event>> importFromICSBytes(Uint8List bytes) async {
    try {
      final content = utf8.decode(bytes, allowMalformed: true);
      final List<Event> events = [];

      // Parsing simplifié du format ICS
      final lines = content.split('\n');
      String? currentTitle;
      String? currentDescription;
      DateTime? currentStart;
      DateTime? currentEnd;
      String? currentLocation;

      for (final line in lines) {
        if (line.startsWith('SUMMARY:')) {
          currentTitle = line.substring(8).trim();
        } else if (line.startsWith('DESCRIPTION:')) {
          currentDescription = line.substring(12).trim();
        } else if (line.startsWith('DTSTART:')) {
          currentStart = _parseICSDateTime(line.substring(8).trim());
        } else if (line.startsWith('DTEND:')) {
          currentEnd = _parseICSDateTime(line.substring(6).trim());
        } else if (line.startsWith('LOCATION:')) {
          currentLocation = line.substring(9).trim();
        } else if (line.startsWith('END:VEVENT')) {
          if (currentTitle != null && currentStart != null) {
            final event = Event(
              id: 'evt_${DateTime.now().millisecondsSinceEpoch}_${events.length}',
              title: currentTitle,
              description: currentDescription ?? '',
              type: EventType.autre,
              dateTime: currentStart,
              endDate: currentEnd,
              location: currentLocation,
            );
            events.add(event);
          }
          // Réinitialiser les variables
          currentTitle = null;
          currentDescription = null;
          currentStart = null;
          currentEnd = null;
          currentLocation = null;
        }
      }

      return events;
    } catch (e) {
      debugPrint('Erreur lors de l\'importation ICS: $e');
      rethrow;
    }
  }

  /// Sélectionne et importe un fichier d'événements
  static Future<List<Event>> pickAndImportFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls', 'ics'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      final selectedFile = result.files.first;
      final bytes = selectedFile.bytes;
      final extension = selectedFile.extension?.toLowerCase() ?? '';

      if (bytes == null) {
        throw Exception(
          'Le fichier sélectionné n\'a pas pu être lu en mémoire. '
          'Réessayez avec un autre fichier.',
        );
      }

      switch (extension) {
        case 'csv':
          return await importFromCSVBytes(bytes);
        case 'xlsx':
        case 'xls':
          return await importFromExcelBytes(bytes);
        case 'ics':
          return await importFromICSBytes(bytes);
        default:
          throw Exception('Format de fichier non supporté: $extension');
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection/importation du fichier: $e');
      rethrow;
    }
  }

  // --- Méthodes privées ---

  static bool _isHeader(List<dynamic> row) {
    if (row.isEmpty) return false;
    final first = row[0].toString().toLowerCase();
    return first.contains('date') ||
        first.contains('titre') ||
        first.contains('heure');
  }

  static List<List<dynamic>> _parseCsvContent(String content) {
    final lines = const LineSplitter().convert(content);
    final rows = <List<dynamic>>[];

    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      rows.add(_splitCsvLine(line));
    }

    return rows;
  }

  static List<dynamic> _splitCsvLine(String line) {
    // Parser très simple: suffit pour un export "tableur" classique sans guillemets complexes.
    // On choisit `;` si c'est le séparateur majoritaire, sinon `,`.
    final semiCount = ';'.allMatches(line).length;
    final commaCount = ','.allMatches(line).length;
    final sep = semiCount > commaCount ? ';' : ',';
    return line.split(sep).map((e) => e.trim()).toList();
  }

  static Event? _parseEventRow(List<dynamic> row) {
    if (row.isEmpty) return null;

    try {
      // Tentative de parsing flexible
      final dateStr = row.isNotEmpty ? row[0].toString().trim() : '';
      final timeStr = row.length > 1 ? row[1].toString().trim() : '';
      final title = row.length > 2 ? row[2].toString().trim() : 'Sans titre';
      final location = row.length > 3 ? row[3].toString().trim() : '';
      final responsible = row.length > 4 ? row[4].toString().trim() : '';

      if (dateStr.isEmpty || title.isEmpty) return null;

      // Parser la date (format DD/MM/YYYY)
      final dateParts = dateStr.split('/');
      if (dateParts.length != 3) return null;

      final day = int.tryParse(dateParts[0]) ?? 1;
      final month = int.tryParse(dateParts[1]) ?? 1;
      final year = int.tryParse(dateParts[2]) ?? DateTime.now().year;

      // Parser l'heure (format HH:MM)
      int hour = 0;
      int minute = 0;
      if (timeStr.isNotEmpty) {
        final timeParts = timeStr.split(':');
        hour = int.tryParse(timeParts[0]) ?? 0;
        minute = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
      }

      final dateTime = DateTime(year, month, day, hour, minute);

      return Event(
        id: 'evt_${DateTime.now().millisecondsSinceEpoch}_${title.hashCode}',
        title: title,
        description: '',
        type: _detectEventType(title),
        dateTime: dateTime,
        location: location.isNotEmpty ? location : null,
        responsiblePerson: responsible.isNotEmpty ? responsible : null,
        time: timeStr.isNotEmpty ? timeStr : null,
      );
    } catch (e) {
      debugPrint('Erreur lors du parsing de la ligne: $e');
      return null;
    }
  }

  static EventType _detectEventType(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('service divin') || lower.contains('sd')) {
      return EventType.serviceDivin;
    }
    if (lower.contains('ecodim')) return EventType.ecodim;
    if (lower.contains('confirmation')) return EventType.confirmation;
    if (lower.contains('jeunesse')) return EventType.jeunesse;
    if (lower.contains('réunion') || lower.contains('reunion')) {
      return EventType.reunion;
    }
    if (lower.contains('visite apostolique') || lower.contains('apostolique')) {
      return EventType.visiteApostolique;
    }
    if (lower.contains('anniversaire')) return EventType.anniversaire;
    if (lower.contains('apôtre') || lower.contains('apotre')) {
      return EventType.apotre;
    }
    if (lower.contains('thème') || lower.contains('theme')) {
      return EventType.theme;
    }
    return EventType.autre;
  }

  static DateTime? _parseICSDateTime(String dateStr) {
    try {
      // Format ICS: YYYYMMDDTHHMMSS ou YYYYMMDD
      if (dateStr.contains('T')) {
        final parts = dateStr.split('T');
        final datePart = parts[0];
        final timePart = parts.length > 1 ? parts[1] : '000000';

        final year = int.parse(datePart.substring(0, 4));
        final month = int.parse(datePart.substring(4, 6));
        final day = int.parse(datePart.substring(6, 8));

        final hour = int.parse(timePart.substring(0, 2));
        final minute = int.parse(timePart.substring(2, 4));
        final second = int.parse(timePart.substring(4, 6));

        return DateTime(year, month, day, hour, minute, second);
      } else {
        final year = int.parse(dateStr.substring(0, 4));
        final month = int.parse(dateStr.substring(4, 6));
        final day = int.parse(dateStr.substring(6, 8));
        return DateTime(year, month, day);
      }
    } catch (e) {
      debugPrint('Erreur lors du parsing de la date ICS: $e');
      return null;
    }
  }
}

