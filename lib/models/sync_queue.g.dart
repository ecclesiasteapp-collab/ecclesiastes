// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncQueueAdapter extends TypeAdapter<SyncQueue> {
  @override
  final int typeId = 7;

  @override
  SyncQueue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueue(
      reportType: fields[0] as String,
      communityId: fields[1] as String,
      dataJson: fields[2] as String,
      userId: fields[5] as String,
      status: fields[3] as String,
    )
      ..createdAt = fields[4] as DateTime
      ..retryCount = fields[6] as int
      ..physicalProofPath = fields[7] as String?
      ..serverReportId = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, SyncQueue obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.reportType)
      ..writeByte(1)
      ..write(obj.communityId)
      ..writeByte(2)
      ..write(obj.dataJson)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(7)
      ..write(obj.physicalProofPath)
      ..writeByte(8)
      ..write(obj.serverReportId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
