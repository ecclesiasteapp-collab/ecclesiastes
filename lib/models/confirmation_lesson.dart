import 'package:hive/hive.dart';

part 'confirmation_lesson.g.dart';

@HiveType(typeId: 6)
class ConfirmationLesson extends HiveObject {
  @HiveField(0) late int lessonNumber;
  @HiveField(1) late String title;
  @HiveField(2) late String objective;
  @HiveField(3) late String contentSummary;
  @HiveField(4) late String resolutionMoiAussi;
  @HiveField(5) late List<String> bibleVerses;
  @HiveField(6) bool isCoreLesson;
  
  ConfirmationLesson({
    required this.lessonNumber,
    required this.title,
    required this.objective,
    required this.contentSummary,
    required this.resolutionMoiAussi,
    required this.bibleVerses,
    this.isCoreLesson = true,
  });
}
