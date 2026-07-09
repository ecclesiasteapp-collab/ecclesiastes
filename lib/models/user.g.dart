// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 101;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String,
      passwordHash: fields[3] as String,
      role: fields[4] as UserRole,
      entityId: fields[5] as String?,
      commissionType: fields[6] as CommissionType?,
      isActive: fields[7] as bool,
      entityLevel: fields[10] as EntityLevel?,
      phone: fields[11] as String?,
      commissionRole: fields[12] as CommissionRole?,
      profil: fields[13] as ProfilDocumentaire?,
      entityRole: fields[14] as String?,
      photoPath: fields[15] as String?,
      status: fields[16] as String,
      pendingSince: fields[17] as DateTime?,
      validatedAt: fields[18] as DateTime?,
      createdAt: fields[8] as DateTime?,
      lastLogin: fields[9] as DateTime?,
    )..personId = fields[19] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.passwordHash)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.entityId)
      ..writeByte(6)
      ..write(obj.commissionType)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.lastLogin)
      ..writeByte(10)
      ..write(obj.entityLevel)
      ..writeByte(11)
      ..write(obj.phone)
      ..writeByte(12)
      ..write(obj.commissionRole)
      ..writeByte(13)
      ..write(obj.profil)
      ..writeByte(14)
      ..write(obj.entityRole)
      ..writeByte(15)
      ..write(obj.photoPath)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.pendingSince)
      ..writeByte(18)
      ..write(obj.validatedAt)
      ..writeByte(19)
      ..write(obj.personId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
