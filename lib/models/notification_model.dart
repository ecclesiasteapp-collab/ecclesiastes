import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 120) // Assurez-vous que ce typeId est unique
class AppNotification extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId; // L'ID de l'utilisateur à notifier

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String message;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  String? relatedObjectId; // Ex: l'ID du rapport rejeté

  @HiveField(7)
  String? relatedObjectType; // Ex: 'report'

  AppNotification({required this.id, required this.userId, required this.title, required this.message, required this.createdAt, this.isRead = false, this.relatedObjectId, this.relatedObjectType});
}
