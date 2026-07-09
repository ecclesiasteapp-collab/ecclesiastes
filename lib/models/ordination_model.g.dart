// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordination_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdinationAdapter extends TypeAdapter<Ordination> {
  @override
  final int typeId = 152;

  @override
  Ordination read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ordination(
      id: fields[0] as String,
      personId: fields[1] as String,
      rank: fields[2] as UserRole,
      date: fields[3] as DateTime,
      entityId: fields[4] as String,
      ordainingMinisterName: fields[5] as String?,
      ordainingMinisterId: fields[6] as String?,
      documentReference: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Ordination obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.rank)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.entityId)
      ..writeByte(5)
      ..write(obj.ordainingMinisterName)
      ..writeByte(6)
      ..write(obj.ordainingMinisterId)
      ..writeByte(7)
      ..write(obj.documentReference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdinationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
