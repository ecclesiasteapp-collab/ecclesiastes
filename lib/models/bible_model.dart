import 'package:hive/hive.dart';

part 'bible_model.g.dart';

@HiveType(typeId: 80)
class BibleBook extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<BibleChapter> chapters;

  BibleBook({required this.id, required this.name, required this.chapters});
}

@HiveType(typeId: 81)
class BibleChapter extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final List<BibleVerse> verses;

  BibleChapter({required this.number, required this.verses});
}

@HiveType(typeId: 82)
class BibleVerse extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String text;

  @HiveField(2)
  bool isFavorite;

  BibleVerse({required this.number, required this.text, this.isFavorite = false});
}

