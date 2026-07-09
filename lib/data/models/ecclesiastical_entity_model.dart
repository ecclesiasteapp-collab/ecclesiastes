import 'package:hive/hive.dart';
import '../../domain/entities/ecclesiastical_entity.dart';

part 'ecclesiastical_entity_model.g.dart';

@HiveType(typeId: 250)
class EcclesiasticalEntityModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int levelIndex;
  @HiveField(3)
  final String? parentId;
  @HiveField(4)
  final Map<String, dynamic>? metadata;

  EcclesiasticalEntityModel({
    required this.id,
    required this.name,
    required this.levelIndex,
    this.parentId,
    this.metadata,
  });

  factory EcclesiasticalEntityModel.fromEntity(EcclesiasticalEntity entity) {
    return EcclesiasticalEntityModel(
      id: entity.id,
      name: entity.name,
      levelIndex: entity.level.index,
      parentId: entity.parentId,
      metadata: entity.metadata,
    );
  }

  EcclesiasticalEntity toEntity() {
    return EcclesiasticalEntity(
      id: id,
      name: name,
      level: EntityLevel.values[levelIndex],
      parentId: parentId,
      metadata: metadata,
    );
  }
}
