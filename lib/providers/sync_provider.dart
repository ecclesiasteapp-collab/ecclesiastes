import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';
import '../services/repository_providers.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final repo = ref.watch(syncRepositoryProvider);
  return SyncService(repo);
});
