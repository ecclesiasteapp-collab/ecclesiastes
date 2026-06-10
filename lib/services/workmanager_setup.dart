// lib/services/workmanager_setup.dart
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:workmanager/workmanager.dart';
import 'sync_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Logique des tâches en arrière-plan (uniquement mobile)
    if (task == 'sync_reports_task' || task == 'syncQueue') {
      await SyncService().trySync();
    }
    return true;
  });
}

Future<void> initWorkmanager() async {
  // ✅ CORRECTION : Ne pas initialiser workmanager sur le Web
  if (kIsWeb) {
    debugPrint('⚠️ Workmanager désactivé sur le Web (non supporté)');
    return;
  }

  try {
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      'sync_task_01',
      'syncQueue',
      frequency: const Duration(minutes: 30),
      constraints: Constraints(networkType: NetworkType.connected),
    );
    debugPrint('✅ Workmanager initialisé (mobile uniquement)');
  } catch (e) {
    debugPrint('❌ Erreur Workmanager: $e');
  }
}
