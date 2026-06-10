// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleBookAdapter extends TypeAdapter<BibleBook> {
  @override
  final int typeId = 80;

  @override
  BibleBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BibleBook(
      id: fields[0] as String,
      name: fields[1] as String,
      chapters: (fields[2] as List).cast<BibleChapter>(),
    );
  }

  @override
  void write(BinaryWriter writer, BibleBook obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BibleChapterAdapter extends TypeAdapter<BibleChapter> {
  @override
  final int typeId = 81;

  @override
  BibleChapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BibleChapter(
      number: fields[0] as int,
      verses: (fields[1] as List).cast<BibleVerse>(),
    );
  }

  @override
  void write(BinaryWriter writer, BibleChapter obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.verses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BibleVerseAdapter extends TypeAdapter<BibleVerse> {
  @override
  final int typeId = 82;

  @override
  BibleVerse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BibleVerse(
      number: fields[0] as int,
      text: fields[1] as String,
      isFavorite: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BibleVerse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleVerseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
