// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modification_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModificationRequestAdapter extends TypeAdapter<ModificationRequest> {
  @override
  final int typeId = 111;

  @override
  ModificationRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModificationRequest(
      id: fields[0] as String,
      ministerId: fields[1] as String,
      ministerName: fields[2] as String,
      resourceType: fields[3] as String,
      resourceId: fields[4] as String,
      request: fields[5] as String,
      status: fields[6] as ModificationStatus,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ModificationRequest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ministerId)
      ..writeByte(2)
      ..write(obj.ministerName)
      ..writeByte(3)
      ..write(obj.resourceType)
      ..writeByte(4)
      ..write(obj.resourceId)
      ..writeByte(5)
      ..write(obj.request)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModificationRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModificationStatusAdapter extends TypeAdapter<ModificationStatus> {
  @override
  final int typeId = 109;

  @override
  ModificationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ModificationStatus.pending;
      case 1:
        return ModificationStatus.approved;
      case 2:
        return ModificationStatus.rejected;
      case 3:
        return ModificationStatus.inProgress;
      case 4:
        return ModificationStatus.completed;
      default:
        return ModificationStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ModificationStatus obj) {
    switch (obj) {
      case ModificationStatus.pending:
        writer.writeByte(0);
        break;
      case ModificationStatus.approved:
        writer.writeByte(1);
        break;
      case ModificationStatus.rejected:
        writer.writeByte(2);
        break;
      case ModificationStatus.inProgress:
        writer.writeByte(3);
        break;
      case ModificationStatus.completed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModificationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
