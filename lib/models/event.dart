
enum EventLevel { territory, field, district, community }

class ChurchEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final EventLevel level;
  final String? commissionId;
  final bool isBlocking; // Les événements apostoliques sont bloquants

  ChurchEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.level,
    this.commissionId,
    this.isBlocking = false,
  });
}
