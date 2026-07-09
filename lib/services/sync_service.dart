import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../models/sync_queue_model.dart';
import '../domain/repositories/sync_repository.dart';

class SyncService {
  final SyncRepository syncRepo;
  final Connectivity _connectivity = Connectivity();

  SyncService(this.syncRepo);

  Future<void> enqueue(String actionType, Map<String, dynamic> data, {String priority = 'normal'}) async {
    final item = SyncQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      actionType: actionType,
      payloadJson: jsonEncode(data),
      createdAt: DateTime.now(),
      priority: priority,
    );
    await syncRepo.addToQueue(item);
    trySync();
  }

  /// Tente de synchroniser la file d'attente
  Future<void> trySync({http.Client? client}) async {
    client ??= http.Client();

    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.every((result) => result == ConnectivityResult.none)) return;

    final pendingItems = await syncRepo.getPendingItems();

    for (var item in pendingItems) {
      item.status = SyncStatus.syncing;
      await syncRepo.updateItem(item);

      try {
        await _resolveConflictsAndSend(item, client);
        item.status = SyncStatus.synced;
        item.isSynced = true;
        await syncRepo.updateItem(item);
      } catch (e) {
        item.status = SyncStatus.failed;
        item.retryCount++;
        await syncRepo.updateItem(item);
      }
    }
  }

  Future<void> _resolveConflictsAndSend(SyncQueueItem item, http.Client client) async {
    final payload = jsonDecode(item.payloadJson);

    if (item.actionType == 'UPDATE_REPORT') {
      final int localVersion = payload['version'];

      // Simulation : Demander au serveur la version actuelle
      // final serverVersion = await _fetchServerVersion(payload['id']);
      const serverVersion = 1; // Simulation

      if (serverVersion > localVersion) {
        throw Exception('Conflit détecté : une version plus récente existe sur le serveur.');
      }
    }

    // Envoi réel (Simulation)
    // await Future.delayed(const Duration(seconds: 1)); // We replace the delay with a real http call
    final response = await client.post(
      Uri.parse('https://api.ecclesiaste.app/v1/sync'),
      headers: {'Content-Type': 'application/json'},
      body: item.payloadJson,
    );

    if (response.statusCode >= 400) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> processQueue() async {
    await SyncService().trySync();
  }
}

