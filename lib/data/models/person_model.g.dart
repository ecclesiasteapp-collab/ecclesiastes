// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonModelAdapter extends TypeAdapter<PersonModel> {
  @override
  final int typeId = 251;

  @override
  PersonModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonModel(
      id: fields[0] as String,
      lastName: fields[1] as String,
      firstName: fields[2] as String,
      postName: fields[3] as String?,
      genderIndex: fields[4] as int,
      birthDate: fields[5] as DateTime,
      email: fields[6] as String?,
      phone: fields[7] as String?,
      photoUrl: fields[8] as String?,
      baptismDate: fields[9] as DateTime?,
      sealingDate: fields[10] as DateTime?,
      confirmationDate: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.postName)
      ..writeByte(4)
      ..write(obj.genderIndex)
      ..writeByte(5)
      ..write(obj.birthDate)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.photoUrl)
      ..writeByte(9)
      ..write(obj.baptismDate)
      ..writeByte(10)
      ..write(obj.sealingDate)
      ..writeByte(11)
      ..write(obj.confirmationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
