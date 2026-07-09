import 'package:hive/hive.dart';
import '../../domain/entities/family.dart';

part 'family_model.g.dart';

@HiveType(typeId: 257)
class FamilyModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String entityId;
  @HiveField(3) final String headOfFamilyId;
  @HiveField(4) final String address;
  @HiveField(5) final List<String> memberIds;

  FamilyModel({
    required this.id,
    required this.name,
    required this.entityId,
    required this.headOfFamilyId,
    required this.address,
    required this.memberIds,
  });

  factory FamilyModel.fromEntity(Family family) {
    return FamilyModel(
      id: family.id,
      name: family.name,
      entityId: family.entityId,
      headOfFamilyId: family.headOfFamilyId,
      address: family.address,
      memberIds: family.memberIds,
    );
  }

  Family toEntity() {
    return Family(
      id: id,
      name: name,
      entityId: entityId,
      headOfFamilyId: headOfFamilyId,
      address: address,
      memberIds: memberIds,
    );
  }
}
