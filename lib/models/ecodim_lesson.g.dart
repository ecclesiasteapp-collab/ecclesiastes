// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecodim_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EcodimLessonAdapter extends TypeAdapter<EcodimLesson> {
  @override
  final int typeId = 5;

  @override
  EcodimLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EcodimLesson(
      id: fields[6] as String,
      date: fields[0] as DateTime,
      title: fields[1] as String,
      bibleText: fields[2] as String,
      pages: fields[3] as String,
      estActiviteBallon: fields[4] as bool,
      themeApplication: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EcodimLesson obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.bibleText)
      ..writeByte(3)
      ..write(obj.pages)
      ..writeByte(4)
      ..write(obj.estActiviteBallon)
      ..writeByte(5)
      ..write(obj.themeApplication)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EcodimLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
