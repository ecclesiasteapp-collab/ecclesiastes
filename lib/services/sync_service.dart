import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/sync_queue_model.dart';

class SyncService {
  final Connectivity _connectivity = Connectivity();

  static Future<void> enqueue(String actionType, Map<String, dynamic> data) async {
    // Note: This implementation seems to be based on a different model (SyncQueueItem)
    // than the one discussed previously (Report). The testing principle remains the same.
    // I will adapt the test to this SyncQueueItem model.
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

  /// Tente de synchroniser la file d'attente
  Future<void> trySync({http.Client? client}) async {
    // If no client is provided for testing, use a real one.
    client ??= http.Client();

    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult.every((result) => result == ConnectivityResult.none)) {
      return; // Pas de réseau
    }

    final box = await Hive.openBox<SyncQueueItem>('sync_queue');
    final pendingItems = box.values.where((item) => item.status == SyncStatus.pending).toList();

    for (var item in pendingItems) {
      item.status = SyncStatus.syncing;
      await item.save();

      try {
        // Logique de résolution de conflit avant envoi
        await _resolveConflictsAndSend(item, client);

        item.status = SyncStatus.synced;
        item.isSynced = true;
        await item.save();
      } catch (e) {
        item.status = SyncStatus.failed;
        item.retryCount++;
// item.errorMessage = e.toString(); // Champ supprimé du modèle
        await item.save();
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

