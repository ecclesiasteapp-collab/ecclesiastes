// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 150;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      id: fields[0] as String,
      ecclesiasticalId: fields[1] as String,
      lastName: fields[2] as String,
      secondName: fields[3] as String,
      firstName: fields[4] as String,
      isMale: fields[5] as bool,
      birthDate: fields[6] as DateTime,
      birthPlace: fields[7] as String?,
      nationality: fields[8] as String?,
      civilStatus: fields[9] as CivilStatus,
      profession: fields[10] as String?,
      educationLevel: fields[11] as String?,
      address: fields[12] as String?,
      phone: fields[13] as String?,
      email: fields[14] as String?,
      photoPath: fields[15] as String?,
      status: fields[16] as String,
      currentEntityId: fields[17] as String,
      currentEntityLevel: fields[18] as EntityLevel,
      fatherName: fields[19] as String?,
      motherName: fields[20] as String?,
      spouseName: fields[21] as String?,
      userId: fields[22] as String?,
      createdAt: fields[23] as DateTime?,
      updatedAt: fields[24] as DateTime?,
      isDeceased: fields[25] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ecclesiasticalId)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.secondName)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.isMale)
      ..writeByte(6)
      ..write(obj.birthDate)
      ..writeByte(7)
      ..write(obj.birthPlace)
      ..writeByte(8)
      ..write(obj.nationality)
      ..writeByte(9)
      ..write(obj.civilStatus)
      ..writeByte(10)
      ..write(obj.profession)
      ..writeByte(11)
      ..write(obj.educationLevel)
      ..writeByte(12)
      ..write(obj.address)
      ..writeByte(13)
      ..write(obj.phone)
      ..writeByte(14)
      ..write(obj.email)
      ..writeByte(15)
      ..write(obj.photoPath)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.currentEntityId)
      ..writeByte(18)
      ..write(obj.currentEntityLevel)
      ..writeByte(19)
      ..write(obj.fatherName)
      ..writeByte(20)
      ..write(obj.motherName)
      ..writeByte(21)
      ..write(obj.spouseName)
      ..writeByte(22)
      ..write(obj.userId)
      ..writeByte(23)
      ..write(obj.createdAt)
      ..writeByte(24)
      ..write(obj.updatedAt)
      ..writeByte(25)
      ..write(obj.isDeceased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
