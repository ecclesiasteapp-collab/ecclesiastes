import 'package:isar/isar.dart';
import '../models/validation_task.dart';
import 'validation_repository.dart';

class IsarValidationRepository implements ValidationRepository {
  final Isar _isar;
  
  IsarValidationRepository(this._isar);

  @override
  Future<void> save(ValidationTask task) async {
    await _isar.writeTxn(() async {
      await _isar.validationTasks.put(task);
    });
  }

  @override
  Future<void> archive(ValidationTask task) async {
    await _isar.writeTxn(() async {
      await _isar.validationTasks.put(task);
    });
  }

  @override
  Future<ValidationTask?> getById(int id) async {
    return await _isar.validationTasks.get(id);
  }
}
