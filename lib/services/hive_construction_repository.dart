import 'package:hive/hive.dart';
import '../domain/repositories/construction_repository.dart';
import '../domain/entities/construction_project.dart';
import 'database_service.dart';

class HiveConstructionRepository implements ConstructionRepository {
  static const String _boxName = 'construction_projects';

  @override
  Future<List<ConstructionProject>> getProjectsForEntity(String entityId) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    return box.values
        .where((m) => m['entity_id'] == entityId)
        .map((m) => _fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> saveProject(ConstructionProject project) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.put(project.id, {
      'id': project.id,
      'title': project.title,
      'entity_id': project.entityId,
      'budget': project.budget,
      'spent': project.spent,
      'progress': project.progress,
      'status': project.status.name,
      'start_date': project.startDate.toIso8601String(),
      'end_date': project.endDate?.toIso8601String(),
    });
  }

  @override
  Future<void> deleteProject(String id) async {
    final box = await DatabaseService.openBox<Map>(_boxName);
    await box.delete(id);
  }

  ConstructionProject _fromMap(Map<String, dynamic> m) {
    return ConstructionProject(
      id: m['id'],
      title: m['title'],
      entityId: m['entity_id'],
      budget: (m['budget'] as num).toDouble(),
      spent: (m['spent'] as num).toDouble(),
      progress: (m['progress'] as num).toDouble(),
      status: ProjectStatus.values.firstWhere((e) => e.name == m['status']),
      startDate: DateTime.parse(m['start_date']),
      endDate: m['end_date'] != null ? DateTime.parse(m['end_date']) : null,
    );
  }
}
