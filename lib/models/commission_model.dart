import 'package:hive/hive.dart';

part 'commission_model.g.dart';

@HiveType(typeId: 106)
class Commission extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String name;
  @HiveField(2) String? description;
  @HiveField(3) late String communityId;
  @HiveField(4) late String communityName;
  @HiveField(5) late String responsibleName;
  @HiveField(6) String? responsibleEmail;
  @HiveField(7) String? deputyName;
  @HiveField(8) String? deputyEmail;
  @HiveField(9) List<String> memberIds;
  @HiveField(10) int expectedMembers;
  @HiveField(11) int activeMembers;
  @HiveField(12) String status; // active, inactive
  @HiveField(13) late DateTime createdAt;

  Commission({
    required this.id,
    required this.name,
    this.description,
    required this.communityId,
    required this.communityName,
    required this.responsibleName,
    this.responsibleEmail,
    this.deputyName,
    this.deputyEmail,
    this.memberIds = const [],
    this.expectedMembers = 0,
    this.activeMembers = 0,
    this.status = 'active',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'communityId': communityId,
      'communityName': communityName,
      'responsibleName': responsibleName,
      'responsibleEmail': responsibleEmail,
      'deputyName': deputyName,
      'deputyEmail': deputyEmail,
      'memberIds': memberIds.join(','),
      'expectedMembers': expectedMembers,
      'activeMembers': activeMembers,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Commission.fromMap(Map<String, dynamic> map) {
    return Commission(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      communityId: map['communityId'] as String,
      communityName: map['communityName'] as String,
      responsibleName: map['responsibleName'] as String,
      responsibleEmail: map['responsibleEmail'] as String?,
      deputyName: map['deputyName'] as String?,
      deputyEmail: map['deputyEmail'] as String?,
      memberIds: (map['memberIds'] as String).split(',').where((e) => e.isNotEmpty).toList(),
      expectedMembers: map['expectedMembers'] as int? ?? 0,
      activeMembers: map['activeMembers'] as int? ?? 0,
      status: map['status'] as String? ?? 'active',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
