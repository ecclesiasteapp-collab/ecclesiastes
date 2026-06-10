import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import '../models/validation_task.dart';
import 'validation_repository.dart';
import 'isar_validation_repository.dart';

class ValidationService {
  final ValidationRepository repository;
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Isar? _isar;

  ValidationService({required this.repository});

  static void init(Isar isar) {
    _isar = isar;
  }

  Future<ValidationTask> submitReport({
    required String reportId,
    required String commissionId,
    required String submitterId,
  }) async {
    final task = ValidationTask(
      entityType: 'REPORT',
      entityId: reportId,
      status: ValidationStatus.submitted,
      submittedBy: submitterId,
    );
    await repository.save(task);
    await _notifyValidators(task);
    return task;
  }

  Future<void> validateCommunity(int taskId, String validatorId) async {
    final task = await repository.getById(taskId);
    if (task == null) throw Exception('Tâche non trouvée');
    if (task.status != ValidationStatus.submitted) {
       throw Exception('Statut invalide pour validation communauté');
    }

    task.status = ValidationStatus.communityValidated;
    task.communityValidatorId = validatorId;
    task.communityValidatedAt = DateTime.now();

    await repository.save(task);
    await _notifyValidators(task);
  }

  Future<void> validateDistrict(int taskId, String validatorId) async {
    final task = await repository.getById(taskId);
    if (task == null) throw Exception('Tâche non trouvée');
    if (task.status != ValidationStatus.communityValidated) {
       throw Exception('Validation communauté manquante');
    }

    task.status = ValidationStatus.archived;
    task.districtValidatorId = validatorId;
    task.districtValidatedAt = DateTime.now();

    await repository.archive(task);
  }

  static Future<bool> approveTask(int taskId, String validatorId, String level) async {
    final isar = _isar;
    if (isar == null) return false;
    final repo = IsarValidationRepository(isar);
    final service = ValidationService(repository: repo);
    try {
      if (level == 'COMMUNITY') {
        await service.validateCommunity(taskId, validatorId);
      } else if (level == 'DISTRICT') {
        await service.validateDistrict(taskId, validatorId);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _notifyValidators(ValidationTask task) async {
    final nextLevel = task.status == ValidationStatus.submitted ? 'District' : 'Champ';
    await _notifications.show(
      id: task.id,
      title: 'Nouvelle validation requise',
      body: 'Un(e) ${task.entityType} attend votre validation au niveau $nextLevel.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('validation', 'Validations', importance: Importance.high),
      ),
    );
  }
}
