import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'image_entity.g.dart';

@HiveType(typeId: 112)
class ImageEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final EntityLevel level;

  @HiveField(4)
  final String responsibleName;

  @HiveField(5)
  final DateTime uploadDate;

  @HiveField(6)
  final String category; // 'annonce', 'responsable', 'membre'

  ImageEntity({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.level,
    required this.responsibleName,
    required this.uploadDate,
    required this.category,
  });

  String get entityPath {
    switch (level) {
      case EntityLevel.internationale:
        return 'assets/images/annonces/internationale/';
      case EntityLevel.territoriale:
        return 'assets/images/annonces/territoriale/';
      case EntityLevel.champ:
        return 'assets/images/annonces/champ/';
      case EntityLevel.regionApostolique:
        return 'assets/images/annonces/region/';
      case EntityLevel.district:
        return 'assets/images/annonces/district/';
      case EntityLevel.communaute:
        return 'assets/images/annonces/communaute/';
    }
  }

  String get fullImagePath => '$entityPath$imagePath';
}

