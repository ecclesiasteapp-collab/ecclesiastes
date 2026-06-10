// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmation_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfirmationLessonAdapter extends TypeAdapter<ConfirmationLesson> {
  @override
  final int typeId = 6;

  @override
  ConfirmationLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfirmationLesson(
      lessonNumber: fields[0] as int,
      title: fields[1] as String,
      objective: fields[2] as String,
      contentSummary: fields[3] as String,
      resolutionMoiAussi: fields[4] as String,
      bibleVerses: (fields[5] as List).cast<String>(),
      isCoreLesson: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ConfirmationLesson obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.lessonNumber)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.objective)
      ..writeByte(3)
      ..write(obj.contentSummary)
      ..writeByte(4)
      ..write(obj.resolutionMoiAussi)
      ..writeByte(5)
      ..write(obj.bibleVerses)
      ..writeByte(6)
      ..write(obj.isCoreLesson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfirmationLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
