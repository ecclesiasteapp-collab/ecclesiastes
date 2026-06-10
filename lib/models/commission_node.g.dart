// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommissionNodeAdapter extends TypeAdapter<CommissionNode> {
  @override
  final int typeId = 15;

  @override
  CommissionNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommissionNode(
      id: fields[0] as String,
      type: fields[1] as CommissionType,
      level: fields[2] as EntityLevel,
      entityId: fields[3] as String,
      parentId: fields[4] as String?,
      leaderId: fields[5] as String?,
      kpiScore: fields[6] as double,
      pendingReports: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CommissionNode obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.parentId)
      ..writeByte(5)
      ..write(obj.leaderId)
      ..writeByte(6)
      ..write(obj.kpiScore)
      ..writeByte(7)
      ..write(obj.pendingReports);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
