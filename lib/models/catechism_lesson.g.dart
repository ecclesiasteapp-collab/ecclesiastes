// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catechism_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CatechismLessonAdapter extends TypeAdapter<CatechismLesson> {
  @override
  final int typeId = 4;

  @override
  CatechismLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CatechismLesson(
      id: fields[0] as int,
      title: fields[1] as String,
      goal: fields[2] as String,
      moiAussi: fields[3] as String,
      isVow: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CatechismLesson obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.goal)
      ..writeByte(3)
      ..write(obj.moiAussi)
      ..writeByte(4)
      ..write(obj.isVow);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatechismLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
