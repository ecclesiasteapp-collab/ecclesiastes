import 'package:hive/hive.dart';

part 'district_model.g.dart';

@HiveType(typeId: 100)
class DistrictModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String code; 
  @HiveField(3) String champId; 
  @HiveField(4) String territorialId; 
  @HiveField(5) String responsibleName; 
  @HiveField(6) String responsiblePhone;
  @HiveField(7) String responsibleEmail;
  @HiveField(8) String siege; 
  @HiveField(9) int communitiesCount; 
  @HiveField(10) int membersCount; 
  @HiveField(11) DateTime createdAt;
  @HiveField(12) bool isActive;
  @HiveField(13) List<String> responsables;

  DistrictModel({
    required this.id,
    required this.name,
    required this.code,
    required this.champId,
    required this.territorialId,
    this.responsibleName = '',
    this.responsiblePhone = '',
    this.responsibleEmail = '',
    this.siege = '',
    this.communitiesCount = 0,
    this.membersCount = 0,
    DateTime? createdAt,
    this.isActive = true,
    this.responsables = const [],
  }) : createdAt = createdAt ?? DateTime.now();
}

