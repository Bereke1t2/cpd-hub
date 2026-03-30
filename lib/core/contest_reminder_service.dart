import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules local notifications (e.g. 15 minutes before a contest).
/// Call [init] once before [scheduleContestReminder].
class ContestReminderService {
  ContestReminderService._();
  static final ContestReminderService instance = ContestReminderService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _androidChannelId = 'cpd_contest_reminders';
  static const _androidChannelName = 'Contest reminders';
  static const _androidChannelDesc = 'Alerts before external and CPD Hub contests start';

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: darwinInit),
    );

    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDesc,
        importance: Importance.high,
      ),
    );
    await android?.requestNotificationsPermission();

    _initialized = true;
  }

  /// Fires 15 minutes before [contestStart] (interpreted in device local time).
  Future<bool> scheduleContestReminder({
    required int notificationId,
    required DateTime contestStart,
    required String contestTitle,
    String? contestUrl,
  }) async {
    await init();
    final startLocal = contestStart.isUtc ? contestStart.toLocal() : contestStart;
    final fireAt = tz.TZDateTime.from(startLocal, tz.local).subtract(const Duration(minutes: 15));
    final now = tz.TZDateTime.now(tz.local);
    if (!fireAt.isAfter(now)) {
      return false;
    }

    final body = contestUrl != null && contestUrl.isNotEmpty
        ? 'Opens in 15 min — tap notification context in system tray after delivery (link in app).'
        : 'Your contest starts in 15 minutes.';

    await _plugin.zonedSchedule(
      notificationId,
      'Contest: $contestTitle',
      body,
      fireAt,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: _androidChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    return true;
  }

  Future<void> cancel(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}
