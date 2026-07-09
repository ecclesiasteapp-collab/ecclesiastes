import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/sync_repository.dart';
import '../models/sync_queue_model.dart';
import 'repository_providers.dart';

class CloudSyncService {
  final SyncRepository _syncRepo;
  bool _isSyncing = false;
  
  CloudSyncService(this._syncRepo);

  bool get isSyncing => _isSyncing;

  /// Lance la synchronisation manuelle
  Future<SyncResult> synchronize() async {
    if (_isSyncing) return SyncResult(success: false, message: 'Synchronisation déjà en cours');
    
    _isSyncing = true;
    int successCount = 0;
    int errorCount = 0;

    try {
      final pendingItems = await _syncRepo.getPendingItems();
      if (pendingItems.isEmpty) {
        return SyncResult(success: true, message: 'Tout est à jour');
      }

      for (var item in pendingItems) {
        item.status = SyncStatus.syncing;
        item.retryCount++;
        await _syncRepo.updateItem(item);

        try {
          // Simulation d'appel API
          await Future.delayed(const Duration(milliseconds: 500));
          
          // Succès simulé à 90%
          if (DateTime.now().millisecond % 10 != 0) {
            item.status = SyncStatus.synced;
            item.isSynced = true;
            item.syncedAt = DateTime.now();
            successCount++;
          } else {
            throw Exception('Erreur de connexion intermittente');
          }
        } catch (e) {
          item.status = SyncStatus.failed;
          item.lastError = e.toString();
          errorCount++;
        }
        await _syncRepo.updateItem(item);
      }

      return SyncResult(
        success: errorCount == 0,
        message: 'Sync terminée: $successCount succès, $errorCount échecs',
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Nettoie les éléments synchronisés pour libérer de l'espace
  Future<void> cleanup() async {
    await _syncRepo.deleteSyncedItems();
  }
}

class SyncResult {
  final bool success;
  final String message;
  SyncResult({required this.success, required this.message});
}

final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  return CloudSyncService(ref.watch(syncRepositoryProvider));
});
