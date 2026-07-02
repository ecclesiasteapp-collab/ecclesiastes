// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 2;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[19] as EventType,
      dateTime: fields[3] as DateTime,
      endDate: fields[4] as DateTime?,
      location: fields[5] as String?,
      address: fields[6] as String?,
      latitude: fields[7] as double?,
      longitude: fields[8] as double?,
      responsiblePerson: fields[9] as String?,
      announcementStatus: fields[14] as AnnouncementStatus,
      category: fields[20] as String?,
      time: fields[21] as String?,
    )
      ..expectedParticipants = fields[10] as int
      ..actualParticipants = fields[11] as int
      ..excusedAbsences = fields[12] as int
      ..participationNotes = fields[13] as String?
      ..daysBeforeAnnouncement = fields[15] as int
      ..sendReminder = fields[16] as bool
      ..createdAt = fields[17] as DateTime
      ..isBirthday = fields[18] as bool;
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.responsiblePerson)
      ..writeByte(10)
      ..write(obj.expectedParticipants)
      ..writeByte(11)
      ..write(obj.actualParticipants)
      ..writeByte(12)
      ..write(obj.excusedAbsences)
      ..writeByte(13)
      ..write(obj.participationNotes)
      ..writeByte(14)
      ..write(obj.announcementStatus)
      ..writeByte(15)
      ..write(obj.daysBeforeAnnouncement)
      ..writeByte(16)
      ..write(obj.sendReminder)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.isBirthday)
      ..writeByte(19)
      ..write(obj.type)
      ..writeByte(20)
      ..write(obj.category)
      ..writeByte(21)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnnouncementAdapter extends TypeAdapter<Announcement> {
  @override
  final int typeId = 3;

  @override
  Announcement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Announcement(
      eventId: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      scheduledDate: fields[3] as DateTime,
      status: fields[4] as AnnouncementStatus,
    )..targetAudience = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Announcement obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.scheduledDate)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.targetAudience);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 0;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.serviceDivin;
      case 1:
        return EventType.ecodim;
      case 2:
        return EventType.confirmation;
      case 3:
        return EventType.jeunesse;
      case 4:
        return EventType.reunion;
      case 5:
        return EventType.visiteApostolique;
      case 6:
        return EventType.anniversaire;
      case 7:
        return EventType.apotre;
      case 8:
        return EventType.theme;
      case 9:
        return EventType.autre;
      default:
        return EventType.serviceDivin;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.serviceDivin:
        writer.writeByte(0);
        break;
      case EventType.ecodim:
        writer.writeByte(1);
        break;
      case EventType.confirmation:
        writer.writeByte(2);
        break;
      case EventType.jeunesse:
        writer.writeByte(3);
        break;
      case EventType.reunion:
        writer.writeByte(4);
        break;
      case EventType.visiteApostolique:
        writer.writeByte(5);
        break;
      case EventType.anniversaire:
        writer.writeByte(6);
        break;
      case EventType.apotre:
        writer.writeByte(7);
        break;
      case EventType.theme:
        writer.writeByte(8);
        break;
      case EventType.autre:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnnouncementStatusAdapter extends TypeAdapter<AnnouncementStatus> {
  @override
  final int typeId = 1;

  @override
  AnnouncementStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnnouncementStatus.draft;
      case 1:
        return AnnouncementStatus.scheduled;
      case 2:
        return AnnouncementStatus.sent;
      case 3:
        return AnnouncementStatus.cancelled;
      default:
        return AnnouncementStatus.draft;
    }
  }

  @override
  void write(BinaryWriter writer, AnnouncementStatus obj) {
    switch (obj) {
      case AnnouncementStatus.draft:
        writer.writeByte(0);
        break;
      case AnnouncementStatus.scheduled:
        writer.writeByte(1);
        break;
      case AnnouncementStatus.sent:
        writer.writeByte(2);
        break;
      case AnnouncementStatus.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
