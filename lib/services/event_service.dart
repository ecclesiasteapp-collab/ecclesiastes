import 'package:hive/hive.dart';
import '../models/isar/event.dart';

class EventService {
  static const String _boxName = 'events_box';

  static Future<Box<Event>> get _box async => await Hive.openBox<Event>(_boxName);

  /// Creates an event in the database
  static Future<Event> createEvent({
    required String id,
    required String title,
    required String description,
    required EventType type,
    required DateTime dateTime,
    String? location,
    String? responsiblePerson,
    int daysBeforeAnnouncement = 3,
    String? category,
  }) async {
    final event = Event(
      id: id,
      title: title,
      description: description,
      type: type,
      dateTime: dateTime,
      endDate: dateTime.add(const Duration(hours: 2)),
      location: location,
      responsiblePerson: responsiblePerson,
      category: category,
    );

    final box = await _box;
    await box.add(event);
    return event;
  }

  /// IMPORTS the actual data from "PROGRAMME DES ACTIVITES DE LA JEUNESSE KSO 2026"
  static Future<void> importYouthProgram2026() async {
    final eventsData = [
      {
        'id': 'jeu_2026_01',
        'title': 'Première rencontre trimestrielle des encadreurs',
        'date': DateTime(2026, 1, 17),
        'desc': 'Rencontre de tous les encadreurs des jeunes à Kanga-M.',
        'loc': 'D/ Kanga-M, C/Kanga-M',
      },
    ];

    for (var e in eventsData) {
      await createEvent(
        id: e['id'] as String,
        title: e['title'] as String,
        description: e['desc'] as String,
        type: EventType.jeunesse,
        dateTime: e['date'] as DateTime,
        location: e['loc'] as String?,
        category: 'JEUNESSE',
      );
    }
  }
}
