import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
enum EventType { 
  @HiveField(0) serviceDivin, 
  @HiveField(1) ecodim, 
  @HiveField(2) confirmation, 
  @HiveField(3) jeunesse, 
  @HiveField(4) reunion, 
  @HiveField(5) visiteApostolique, 
  @HiveField(6) anniversaire, 
  @HiveField(7) apotre,
  @HiveField(8) theme,
  @HiveField(9) autre 
}

@HiveType(typeId: 1)
enum AnnouncementStatus { 
  @HiveField(0) draft, 
  @HiveField(1) scheduled, 
  @HiveField(2) sent, 
  @HiveField(3) cancelled 
}

@HiveType(typeId: 2)
class Event extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String title;
  @HiveField(2) late String description;
  @HiveField(3) late DateTime dateTime;
  @HiveField(4) DateTime? endDate;
  @HiveField(5) String? location;
  @HiveField(6) String? address;
  @HiveField(7) double? latitude;
  @HiveField(8) double? longitude;
  @HiveField(9) String? responsiblePerson;
  
  @HiveField(10) int expectedParticipants = 0;
  @HiveField(11) int actualParticipants = 0;
  @HiveField(12) int excusedAbsences = 0;
  @HiveField(13) String? participationNotes;

  @HiveField(14) late AnnouncementStatus announcementStatus;
  @HiveField(15) int daysBeforeAnnouncement = 7;
  @HiveField(16) bool sendReminder = true;
  
  @HiveField(17) late DateTime createdAt;
  @HiveField(18) bool isBirthday = false;
  
  @HiveField(19) late EventType type;
  @HiveField(20) String? category; // 'ECODIM', 'JEUNESSE', etc.
  @HiveField(21) String? time;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dateTime,
    this.endDate,
    this.location,
    this.address,
    this.latitude,
    this.longitude,
    this.responsiblePerson,
    this.announcementStatus = AnnouncementStatus.draft,
    this.category,
    this.time,
  }) : createdAt = DateTime.now();

  // Helper for old code compatibility
  DateTime get date => dateTime;
}

@HiveType(typeId: 3)
class Announcement extends HiveObject {
  @HiveField(0) late String eventId;
  @HiveField(1) late String title;
  @HiveField(2) late String content;
  @HiveField(3) late DateTime scheduledDate;
  @HiveField(4) late AnnouncementStatus status;
  @HiveField(5) String? targetAudience;

  Announcement({
    required this.eventId,
    required this.title,
    required this.content,
    required this.scheduledDate,
    this.status = AnnouncementStatus.scheduled,
  });
}
