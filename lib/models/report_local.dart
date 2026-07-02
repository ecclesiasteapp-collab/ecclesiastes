import 'dart:convert';
import 'package:hive/hive.dart';

part 'report_local.g.dart';

@HiveType(typeId: 8)
class ReportLocal extends HiveObject {
  @HiveField(0)
  late String syncQueueId;
  @HiveField(1)
  late String reportType;
  @HiveField(2)
  late String contentJson;
  @HiveField(3)
  late DateTime createdAt;
  @HiveField(4)
  late String authorId;
  @HiveField(5)
  String? confidentialNotes;

  Map<String, dynamic> get content => jsonDecode(contentJson);
  set content(Map<String, dynamic> value) => contentJson = jsonEncode(value);
}

