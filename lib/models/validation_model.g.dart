// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ValidationModelAdapter extends TypeAdapter<ValidationModel> {
  @override
  final int typeId = 117;

  @override
  ValidationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ValidationModel(
      id: fields[0] as String,
      reportId: fields[1] as String,
      validatorRole: fields[2] as String,
      validatorName: fields[3] as String,
      decision: fields[4] as String,
      comments: fields[5] as String?,
      validatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ValidationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.reportId)
      ..writeByte(2)
      ..write(obj.validatorRole)
      ..writeByte(3)
      ..write(obj.validatorName)
      ..writeByte(4)
      ..write(obj.decision)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.validatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
