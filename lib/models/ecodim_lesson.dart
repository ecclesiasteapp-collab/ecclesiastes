import 'package:hive/hive.dart';

part 'ecodim_lesson.g.dart';

@HiveType(typeId: 5)
class EcodimLesson extends HiveObject {
  @HiveField(0) late DateTime date;
  @HiveField(1) late String title;
  @HiveField(2) late String bibleText;
  @HiveField(3) late String pages;
  @HiveField(4) late bool estActiviteBallon;
  @HiveField(5) String? themeApplication;
  @HiveField(6) late String id;
  
  EcodimLesson({
    required this.id,
    required this.date,
    required this.title,
    required this.bibleText,
    required this.pages,
    this.estActiviteBallon = false,
    this.themeApplication,
  });
}

