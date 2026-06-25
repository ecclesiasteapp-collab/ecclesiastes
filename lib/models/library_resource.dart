import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'library_resource.g.dart';

@HiveType(typeId: 103)
enum LibraryCategory {
  @HiveField(0) cantiques,
  @HiveField(1) catechisme,
  @HiveField(2) liturgie,
  @HiveField(3) penseeDirectrice,
  @HiveField(4) programmes,
  @HiveField(5) visionEglise,
}

@HiveType(typeId: 104)
enum ResourceType {
  @HiveField(0) pdf,
  @HiveField(1) audio,
  @HiveField(2) image,
  @HiveField(3) text,
}

@HiveType(typeId: 108)
class LibraryResource extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String resourcePath;

  @HiveField(3)
  final LibraryCategory category;

  @HiveField(4)
  final ResourceType type;

  @HiveField(5)
  final EntityLevel? level;

  @HiveField(6)
  final DateTime uploadDate;

  @HiveField(7)
  final String? description;

  LibraryResource({
    required this.id,
    required this.title,
    required this.resourcePath,
    required this.category,
    required this.type,
    this.level,
    required this.uploadDate,
    this.description,
  });

  String get categoryPath {
    switch (category) {
      case LibraryCategory.cantiques:
        return 'assets/librairie/cantiques/';
      case LibraryCategory.catechisme:
        return 'assets/librairie/catechisme/';
      case LibraryCategory.liturgie:
        return 'assets/librairie/liturgie/';
      case LibraryCategory.penseeDirectrice:
        return 'assets/librairie/pensee_directrice/';
      case LibraryCategory.programmes:
        return 'assets/librairie/programmes/';
      case LibraryCategory.visionEglise:
        return 'assets/librairie/vision_eglise/';
    }
  }

  String get fullPath => '$categoryPath$resourcePath';
}
