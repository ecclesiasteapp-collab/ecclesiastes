import 'package:hive/hive.dart';
import '../domain/repositories/governance_repository.dart';
import '../models/ordination_model.dart';
import '../models/nomination_model.dart';
import 'database_service.dart';

class HiveGovernanceRepository implements GovernanceRepository {
  @override
  Future<List<Ordination>> getOrdinationsForPerson(String personId) async {
    final box = await DatabaseService.openBox<Ordination>(DatabaseService.ordinationsBoxName);
    return box.values.where((o) => o.personId == personId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Nomination>> getNominationsForPerson(String personId) async {
    final box = await DatabaseService.openBox<Nomination>(DatabaseService.nominationsBoxName);
    return box.values.where((n) => n.personId == personId).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  @override
  Future<List<Nomination>> getNominationsForEntity(String entityId) async {
    final box = await DatabaseService.openBox<Nomination>(DatabaseService.nominationsBoxName);
    return box.values.where((n) => n.entityId == entityId && n.isActive).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  @override
  Future<void> saveOrdination(Ordination ordination) async {
    final box = await DatabaseService.openBox<Ordination>(DatabaseService.ordinationsBoxName);
    await box.put(ordination.id, ordination);
  }

  @override
  Future<void> saveNomination(Nomination nomination) async {
    final box = await DatabaseService.openBox<Nomination>(DatabaseService.nominationsBoxName);
    await box.put(nomination.id, nomination);
  }

  @override
  Future<void> deleteOrdination(String id) async {
    final box = await DatabaseService.openBox<Ordination>(DatabaseService.ordinationsBoxName);
    await box.delete(id);
  }

  @override
  Future<void> deleteNomination(String id) async {
    final box = await DatabaseService.openBox<Nomination>(DatabaseService.nominationsBoxName);
    await box.delete(id);
  }
}
