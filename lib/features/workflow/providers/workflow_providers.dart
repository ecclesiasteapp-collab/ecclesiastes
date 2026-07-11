import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/workflow_repository.dart';
import '../data/repositories/hive_workflow_repository.dart';
import '../application/workflow_engine.dart';

// Repository Provider
final workflowRepositoryProvider = Provider<WorkflowRepository>((ref) {
  return HiveWorkflowRepository();
});

// Engine Provider
final workflowEngineProvider = Provider<WorkflowEngine>((ref) {
  final repository = ref.watch(workflowRepositoryProvider);
  return WorkflowEngine(repository);
});

// Pending Tasks Provider
final pendingTasksProvider = FutureProvider.family<List, String>((ref, entityId) async {
  final repository = ref.watch(workflowRepositoryProvider);
  return repository.getInstancesByEntity(entityId);
});
