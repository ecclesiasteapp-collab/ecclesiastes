import 'package:flutter/foundation.dart' show debugPrint;

const String syncTaskName = 'com.ecclesiastes.sync_reports_task';

class BackgroundSyncService {
  static Future<void> initialize() async {
    debugPrint('BackgroundSyncService désactivé sur cette plateforme');
  }

  static Future<void> schedulePeriodicSync() async {
    debugPrint(
        'Planification de synchronisation indisponible sur cette plateforme');
  }

  static Future<void> triggerOneOffSync() async {
    debugPrint('Synchronisation one-off indisponible sur cette plateforme');
  }
}

