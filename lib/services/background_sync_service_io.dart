import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'package:ecclesiastes/config/app_config.dart';
import 'package:ecclesiastes/models/church_report.dart';
import 'package:ecclesiastes/models/hierarchy_models.dart';
import 'package:ecclesiastes/services/notification_service.dart';
import 'package:ecclesiastes/services/report_persistence_service.dart';

const String syncTaskName = 'com.ecclesiastes.sync_reports_task';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(ChurchReportAdapter().typeId)) {
        Hive.registerAdapter(ChurchReportAdapter());
      }
      if (!Hive.isAdapterRegistered(EntityLevelAdapter().typeId)) {
        Hive.registerAdapter(EntityLevelAdapter());
      }
      if (!Hive.isAdapterRegistered(UserRoleAdapter().typeId)) {
        Hive.registerAdapter(UserRoleAdapter());
      }
      if (!Hive.isAdapterRegistered(CommissionRoleAdapter().typeId)) {
        Hive.registerAdapter(CommissionRoleAdapter());
      }
      if (!Hive.isAdapterRegistered(ProfilDocumentaireAdapter().typeId)) {
        Hive.registerAdapter(ProfilDocumentaireAdapter());
      }

      final boxName = ReportPersistenceService().boxName;
      await Hive.openBox<ChurchReport>(boxName);
      await NotificationService.init();

      final dio = Dio();
      final apiUrl = '${AppConfig.apiBaseUrl}/api/sync/updates';

      try {
        final response = await dio.get(apiUrl);

        if (response.statusCode == 200) {
          final updates = response.data as List<dynamic>;
          for (final update in updates) {
            if (update['status'] == 'REJECTED') {
              final reportId = update['id'] as String;
              final reason = update['rejection_reason'] as String;
              await ReportPersistenceService().rejectReport(reportId, reason);
            }
          }
          debugPrint(
            'Background sync successful: ${updates.length} updates processed.',
          );
        } else {
          debugPrint(
            'Background sync failed with status: ${response.statusCode}',
          );
        }
      } on DioException catch (e) {
        debugPrint('Background sync Dio error: ${e.message}');
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  });
}

class BackgroundSyncService {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> schedulePeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      'periodic-sync-001',
      syncTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }

  static Future<void> triggerOneOffSync() async {
    await Workmanager().registerOneOffTask(
      'oneoff-sync-${DateTime.now().millisecondsSinceEpoch}',
      syncTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

