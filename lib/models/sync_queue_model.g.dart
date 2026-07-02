// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_queue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncQueueItemAdapter extends TypeAdapter<SyncQueueItem> {
  @override
  final int typeId = 118;

  @override
  SyncQueueItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncQueueItem(
      id: fields[0] as String,
      actionType: fields[1] as String,
      payloadJson: fields[2] as String,
      createdAt: fields[3] as DateTime,
      isSynced: fields[4] as bool,
      status: fields[5] as String,
      retryCount: fields[6] as int,
      priority: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SyncQueueItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actionType)
      ..writeByte(2)
      ..write(obj.payloadJson)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isSynced)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncQueueItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
