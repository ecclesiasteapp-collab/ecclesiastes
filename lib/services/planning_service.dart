import '../models/event.dart';

class PlanningService {
  /// Vérifie si une nouvelle activité entre en conflit avec la hiérarchie
  static List<ChurchEvent> detectConflicts(ChurchEvent newEvent, List<ChurchEvent> hierarchyEvents) {
    return hierarchyEvents.where((hEvent) {
      // Vérification du chevauchement de dates
      final bool overlap = newEvent.start.isBefore(hEvent.end) && hEvent.start.isBefore(newEvent.end);
      
      if (overlap) {
        // Un événement supérieur bloquant interdit toute activité locale
        if (hEvent.isBlocking && hEvent.level.index < newEvent.level.index) {
          return true;
        }
      }
      return false;
    }).toList();
  }
}

