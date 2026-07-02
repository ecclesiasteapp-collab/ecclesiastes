// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DistrictModelAdapter extends TypeAdapter<DistrictModel> {
  @override
  final int typeId = 100;

  @override
  DistrictModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DistrictModel(
      id: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String,
      champId: fields[3] as String,
      territorialId: fields[4] as String,
      responsibleName: fields[5] as String,
      responsiblePhone: fields[6] as String,
      responsibleEmail: fields[7] as String,
      siege: fields[8] as String,
      communitiesCount: fields[9] as int,
      membersCount: fields[10] as int,
      createdAt: fields[11] as DateTime?,
      isActive: fields[12] as bool,
      responsables: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DistrictModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.champId)
      ..writeByte(4)
      ..write(obj.territorialId)
      ..writeByte(5)
      ..write(obj.responsibleName)
      ..writeByte(6)
      ..write(obj.responsiblePhone)
      ..writeByte(7)
      ..write(obj.responsibleEmail)
      ..writeByte(8)
      ..write(obj.siege)
      ..writeByte(9)
      ..write(obj.communitiesCount)
      ..writeByte(10)
      ..write(obj.membersCount)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.responsables);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
