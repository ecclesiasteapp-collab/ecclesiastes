import 'package:hive/hive.dart';
import 'attachment_model.dart';
import 'hierarchy_models.dart';

part 'event.g.dart';

@HiveType(typeId: 110)
class ChurchEvent extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late DateTime start;

  @HiveField(3)
  late DateTime end;

  @HiveField(4)
  late EntityLevel level;

  @HiveField(5)
  late String? commissionId;

  @HiveField(6)
  late bool isBlocking;

  @HiveField(7)
  late String description;

  @HiveField(8)
  late Attachment? dataAttachment;

  ChurchEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.level,
    this.description = '',
    this.commissionId,
    this.isBlocking = false,
    this.dataAttachment,
  });
}

