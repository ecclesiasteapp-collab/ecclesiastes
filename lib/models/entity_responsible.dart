import 'package:hive/hive.dart';
import 'legacy_models.dart'; // Pour EntityLevel legacy si besoin

part 'entity_responsible.g.dart';

@HiveType(typeId: 107)
class EntityResponsible extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String entityId;
  @HiveField(2) late String entityName;
  @HiveField(3) late String level; // commission, district, community (as String for flexibility)
  @HiveField(4) late String principalName;
  @HiveField(5) String? principalEmail;
  @HiveField(6) String? deputyName;
  @HiveField(7) String? deputyEmail;
  @HiveField(8) late DateTime startDate;
  @HiveField(9) DateTime? endDate;
  @HiveField(10) bool isActive;

  EntityResponsible({
    required this.id,
    required this.entityId,
    required this.entityName,
    required this.level,
    required this.principalName,
    this.principalEmail,
    this.deputyName,
    this.deputyEmail,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entityId': entityId,
      'entityName': entityName,
      'entityLevel': level,
      'principalName': principalName,
      'principalEmail': principalEmail,
      'deputyName': deputyName,
      'deputyEmail': deputyEmail,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory EntityResponsible.fromMap(Map<String, dynamic> map) {
    return EntityResponsible(
      id: map['id'] as String,
      entityId: map['entityId'] as String,
      entityName: map['entityName'] as String,
      level: map['entityLevel'] as String,
      principalName: map['principalName'] as String,
      principalEmail: map['principalEmail'] as String?,
      deputyName: map['deputyName'] as String?,
      deputyEmail: map['deputyEmail'] as String?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
