// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nomination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NominationAdapter extends TypeAdapter<Nomination> {
  @override
  final int typeId = 153;

  @override
  Nomination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nomination(
      id: fields[0] as String,
      personId: fields[1] as String,
      functionName: fields[2] as String,
      entityId: fields[3] as String,
      type: fields[4] as String,
      startDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime?,
      nominatingAuthorityName: fields[7] as String?,
      nominatingAuthorityId: fields[8] as String?,
      decisionReference: fields[9] as String?,
      isActive: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Nomination obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.functionName)
      ..writeByte(3)
      ..write(obj.entityId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.nominatingAuthorityName)
      ..writeByte(8)
      ..write(obj.nominatingAuthorityId)
      ..writeByte(9)
      ..write(obj.decisionReference)
      ..writeByte(10)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NominationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
