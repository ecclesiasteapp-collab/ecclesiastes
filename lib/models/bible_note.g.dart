// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleNoteAdapter extends TypeAdapter<BibleNote> {
  @override
  final int typeId = 83;

  @override
  BibleNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BibleNote(
      id: fields[0] as String,
      bookId: fields[1] as String,
      chapterNumber: fields[2] as int,
      verseNumber: fields[3] as int,
      content: fields[4] as String,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BibleNote obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.chapterNumber)
      ..writeByte(3)
      ..write(obj.verseNumber)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
