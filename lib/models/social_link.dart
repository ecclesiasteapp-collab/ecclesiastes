import 'package:hive/hive.dart';
import 'hierarchy_models.dart';

part 'social_link.g.dart';

@HiveType(typeId: 119)
class SocialLink extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String entityName;
  @HiveField(2)
  final String platform; // 'youtube', 'facebook', 'instagram'
  @HiveField(3)
  final String url;
  @HiveField(4)
  final EntityLevel level;
  @HiveField(5)
  final bool isOfficial;

  SocialLink({
    required this.id,
    required this.entityName,
    required this.platform,
    required this.url,
    required this.level,
    this.isOfficial = false,
  });
}

