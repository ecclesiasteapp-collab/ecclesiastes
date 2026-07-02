import 'package:hive/hive.dart';
import 'attachment_model.dart';

part 'news_model.g.dart';

@HiveType(typeId: 40)
class News extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String imageUrl;
  @HiveField(3)
  late String content;
  @HiveField(4)
  late DateTime date;
  @HiveField(5)
  late Attachment? posterAttachment;

  News({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.date,
    this.posterAttachment,
  });
}

