import '../../domain/entities/construction_project.dart';

abstract class ConstructionRepository {
  Future<List<ConstructionProject>> getProjectsForEntity(String entityId);
  Future<void> saveProject(ConstructionProject project);
  Future<void> deleteProject(String id);
}
