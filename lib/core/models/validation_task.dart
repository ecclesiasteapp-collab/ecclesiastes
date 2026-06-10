import 'package:isar/isar.dart';

part 'validation_task.g.dart';

enum ValidationStatus { draft, submitted, communityValidated, districtValidated, champValidated, archived, rejected }

@collection
class ValidationTask {
  Id id = Isar.autoIncrement;
  @Index() late String entityType; // 'REPORT', 'EVENT', 'ANNOUNCEMENT', 'HIERARCHY_CHANGE'
  @Index() late String entityId;
  @Index() @enumerated late ValidationStatus status;
  DateTime createdAt = DateTime.now();
  
  String? submittedBy;
  String? communityValidatorId;
  DateTime? communityValidatedAt;
  String? districtValidatorId;
  DateTime? districtValidatedAt;
  String? champValidatorId;
  DateTime? champValidatedAt;
  
  String? rejectionReason;
  // Note: Isar map storage requires specific handling or use of json string
  String? metadataJson; 
  
  ValidationTask({
    required this.entityType,
    required this.entityId,
    this.status = ValidationStatus.draft,
    this.submittedBy,
  });
  
  bool get isValideDouble => status == ValidationStatus.champValidated || status == ValidationStatus.archived;

  bool isOverdue(DateTime now, {int timeoutHours = 48}) {
    return now.difference(createdAt).inHours >= timeoutHours;
  }
}
