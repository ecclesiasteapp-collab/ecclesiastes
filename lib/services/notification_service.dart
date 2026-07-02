// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true,
    );
    
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    await _createChannel(id: 'ecclesiastes_workflow', name: 'Validations & Rapports', importance: Importance.high);
    await _createChannel(id: 'ecclesiastes_reminders', name: 'Rappels', importance: Importance.defaultImportance);
    _initialized = true;
  }

  static Future<void> _createChannel({required String id, required String name, required Importance importance}) async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(AndroidNotificationChannel(id, name, importance: importance));
    }
  }

  static Future<void> sendImmediate({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = 'ecclesiastes_workflow',
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelId),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  static Future<void> schedule({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    String? payload,
    String channelId = 'ecclesiastes_reminders',
  }) async {
    final tz.TZDateTime scheduled = tz.TZDateTime.from(dateTime, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelId),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }
}

