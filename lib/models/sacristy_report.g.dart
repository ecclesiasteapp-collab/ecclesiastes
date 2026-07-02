// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sacristy_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SacristyReportAdapter extends TypeAdapter<SacristyReport> {
  @override
  final int typeId = 105;

  @override
  SacristyReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SacristyReport(
      id: fields[0] as String,
      eventId: fields[1] as String,
      date: fields[2] as DateTime,
      memberCount: fields[3] as int,
      visitorCount: fields[4] as int,
      presentMembers: (fields[5] as List).cast<String>(),
      saintSealed: (fields[6] as List).cast<String>(),
      churchOrder: fields[7] as String,
      offeringAmount: fields[8] as double,
      chaliceOpeners: (fields[9] as List).cast<String>(),
      chaliceClosers: (fields[10] as List).cast<String>(),
      holySceneDistributors: (fields[11] as List).cast<String>(),
      sickList: (fields[12] as List).cast<String>(),
      observations: fields[13] as String,
      reporterName: fields[14] as String,
      createdAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SacristyReport obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.memberCount)
      ..writeByte(4)
      ..write(obj.visitorCount)
      ..writeByte(5)
      ..write(obj.presentMembers)
      ..writeByte(6)
      ..write(obj.saintSealed)
      ..writeByte(7)
      ..write(obj.churchOrder)
      ..writeByte(8)
      ..write(obj.offeringAmount)
      ..writeByte(9)
      ..write(obj.chaliceOpeners)
      ..writeByte(10)
      ..write(obj.chaliceClosers)
      ..writeByte(11)
      ..write(obj.holySceneDistributors)
      ..writeByte(12)
      ..write(obj.sickList)
      ..writeByte(13)
      ..write(obj.observations)
      ..writeByte(14)
      ..write(obj.reporterName)
      ..writeByte(15)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SacristyReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
