// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportLocalAdapter extends TypeAdapter<ReportLocal> {
  @override
  final int typeId = 8;

  @override
  ReportLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportLocal()
      ..syncQueueId = fields[0] as String
      ..reportType = fields[1] as String
      ..contentJson = fields[2] as String
      ..createdAt = fields[3] as DateTime
      ..authorId = fields[4] as String
      ..confidentialNotes = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ReportLocal obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.syncQueueId)
      ..writeByte(1)
      ..write(obj.reportType)
      ..writeByte(2)
      ..write(obj.contentJson)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.authorId)
      ..writeByte(5)
      ..write(obj.confidentialNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
