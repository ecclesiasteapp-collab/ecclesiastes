import 'package:hive/hive.dart';

part 'bible_note.g.dart';

@HiveType(typeId: 83)
class BibleNote extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bookId;

  @HiveField(2)
  final int chapterNumber;

  @HiveField(3)
  final int verseNumber;

  @HiveField(4)
  String content; // Sera chiffré avant stockage via EncryptionService

  @HiveField(5)
  final DateTime createdAt;

  BibleNote({
    required this.id,
    required this.bookId,
    required this.chapterNumber,
    required this.verseNumber,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

