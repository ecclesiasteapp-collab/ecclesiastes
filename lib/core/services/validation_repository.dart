import '../models/validation_task.dart';

abstract class ValidationRepository {
  Future<void> save(ValidationTask task);
  Future<void> archive(ValidationTask task);
  Future<ValidationTask?> getById(int id);
}
