import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/image_entity.dart';
import '../models/hierarchy_models.dart';

class ImageEntityService {
  static final ImageEntityService _instance = ImageEntityService._internal();
  factory ImageEntityService() => _instance;
  ImageEntityService._internal();

  static const String _boxName = 'image_entities';

  Future<Box<ImageEntity>> get _box async => await Hive.openBox<ImageEntity>(_boxName);

  Future<void> saveImage(ImageEntity image) async {
    final box = await _box;
    await box.put(image.id, image);
  }

  Future<List<ImageEntity>> getAnnoncesByLevel(EntityLevel level) async {
    final box = await _box;
    return box.values.where((img) =>
      img.level == level && img.category == 'annonce'
    ).toList();
  }

  Future<List<ImageEntity>> getResponsableImages(EntityLevel level) async {
    final box = await _box;
    return box.values.where((img) =>
      img.level == level && img.category == 'responsable'
    ).toList();
  }
}
