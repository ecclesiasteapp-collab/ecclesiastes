import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/sync_queue_model.dart';

class SyncService {
  final Connectivity _connectivity = Connectivity();

  static Future<void> enqueue(String actionType, Map<String, dynamic> data) async {
    final box = Hive.box<SyncQueueItem>('sync_queue');
    final item = SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      actionType: actionType,
      payloadJson: jsonEncode(data),
      createdAt: DateTime.now(),
    );
    await box.add(item);
    SyncService().trySync();
  }

  /// Tente de synchroniser la file d'attente (Rendu PUBLIC pour WorkManager)
  Future<void> trySync() async {
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    
    // Correction : vérifier si la liste contient uniquement 'none'
    if (connectivityResult.every((result) => result == ConnectivityResult.none)) {
      return; // Pas de réseau
    }

    final box = await Hive.openBox<SyncQueueItem>('sync_queue');
    final pendingItems = box.values.where((item) => item.status == SyncStatus.pending).toList();

    for (var item in pendingItems) {
      item.status = SyncStatus.syncing;
      await item.save();

      try {
        await _sendToServer(item); 
        item.status = SyncStatus.synced;
        item.isSynced = true;
        await item.save();
        debugPrint('✅ Sync réussi pour: ${item.id}');
      } catch (e) {
        item.status = SyncStatus.failed;
        item.retryCount++;
        item.errorMessage = e.toString();
        await item.save();
        debugPrint('❌ Sync échoué pour: ${item.id} - $e');
      }
    }
  }

  Future<void> _sendToServer(SyncQueueItem item) async {
    // Logique d'envoi réelle à implémenter ou à appeler depuis un autre service
    // Pour l'instant, on simule un succès
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<void> processQueue() async {
    await SyncService().trySync();
  }

  static Future<void> init() async {
    // Initialisation si nécessaire
  }
}
