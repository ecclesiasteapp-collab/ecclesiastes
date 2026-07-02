import 'package:hive/hive.dart';

part 'catechism_lesson.g.dart';

@HiveType(typeId: 4)
class CatechismLesson extends HiveObject {
  @HiveField(0) late int id;
  @HiveField(1) late String title;
  @HiveField(2) late String goal; // Objectif pédagogique
  @HiveField(3) late String moiAussi; // La résolution "Moi aussi, je veux..."
  @HiveField(4) bool isVow; // Leçon 29: La Confirmation

  CatechismLesson({
    required this.id, required this.title, required this.goal,
    required this.moiAussi, this.isVow = false,
  });
}

