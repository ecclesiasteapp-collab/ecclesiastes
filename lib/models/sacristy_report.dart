import 'package:hive/hive.dart';

part 'sacristy_report.g.dart';

@HiveType(typeId: 105)
class SacristyReport extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String eventId;
  @HiveField(2) late DateTime date;
  @HiveField(3) late int memberCount;
  @HiveField(4) late int visitorCount;
  @HiveField(5) late List<String> presentMembers;
  @HiveField(6) late List<String> saintSealed;
  @HiveField(7) late String churchOrder;
  @HiveField(8) late double offeringAmount;
  @HiveField(9) late List<String> chaliceOpeners;
  @HiveField(10) late List<String> chaliceClosers;
  @HiveField(11) late List<String> holySceneDistributors;
  @HiveField(12) late List<String> sickList;
  @HiveField(13) late String observations;
  @HiveField(14) late String reporterName;
  @HiveField(15) late DateTime createdAt;

  SacristyReport({
    required this.id,
    required this.eventId,
    required this.date,
    required this.memberCount,
    required this.visitorCount,
    this.presentMembers = const [],
    this.saintSealed = const [],
    this.churchOrder = '',
    this.offeringAmount = 0.0,
    this.chaliceOpeners = const [],
    this.chaliceClosers = const [],
    this.holySceneDistributors = const [],
    this.sickList = const [],
    this.observations = '',
    required this.reporterName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'date': date.toIso8601String(),
      'memberCount': memberCount,
      'visitorCount': visitorCount,
      'presentMembers': presentMembers.join('|'),
      'saintSealed': saintSealed.join('|'),
      'churchOrder': churchOrder,
      'offeringAmount': offeringAmount,
      'chaliceOpeners': chaliceOpeners.join('|'),
      'chaliceClosers': chaliceClosers.join('|'),
      'holySceneDistributors': holySceneDistributors.join('|'),
      'sickList': sickList.join('|'),
      'observations': observations,
      'reporterName': reporterName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SacristyReport.fromMap(Map<String, dynamic> map) {
    return SacristyReport(
      id: map['id'] as String,
      eventId: map['eventId'] as String,
      date: DateTime.parse(map['date'] as String),
      memberCount: map['memberCount'] as int,
      visitorCount: map['visitorCount'] as int,
      presentMembers: (map['presentMembers'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      saintSealed: (map['saintSealed'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      churchOrder: map['churchOrder'] as String,
      offeringAmount: double.tryParse(map['offeringAmount']?.toString() ?? '0') ?? 0.0,
      chaliceOpeners: (map['chaliceOpeners'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      chaliceClosers: (map['chaliceClosers'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      holySceneDistributors: (map['holySceneDistributors'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      sickList: (map['sickList'] as String).split('|').where((e) => e.isNotEmpty).toList(),
      observations: map['observations'] as String,
      reporterName: map['reporterName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

