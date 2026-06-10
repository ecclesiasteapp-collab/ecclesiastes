import 'package:hive/hive.dart';

part 'report_model.g.dart';

@HiveType(typeId: 70)
class ReportModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String type; 
  @HiveField(2) late String communityId;
  @HiveField(3) late String communityName;
  @HiveField(4) late String districtName;
  @HiveField(5) late String champName;
  @HiveField(6) late Map<String, dynamic> formData;
  @HiveField(7) late String status; 
  @HiveField(8) late String createdBy;
  @HiveField(9) late DateTime createdAt;
  @HiveField(10) String? rejectionReason;
  @HiveField(11) String? signaturesJson; 

  ReportModel({
    required this.id,
    required this.type,
    required this.communityId,
    required this.communityName,
    required this.districtName,
    required this.champName,
    required this.formData,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.rejectionReason,
    this.signaturesJson,
  });
}
