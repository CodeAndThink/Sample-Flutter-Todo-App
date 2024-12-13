import 'package:alarm/alarm.dart';
import 'package:todo_app/gen/assets.gen.dart';

class AlarmNotification {
  static Future<void> createAlarm(
      int id,
      DateTime activeTime,
      String alarmTitle,
      String alarmContent,
      String alarmIcon,
      String stopButtonTitle) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: activeTime,
      assetAudioPath: Assets.audios.alarmSource,
      loopAudio: true,
      vibrate: true,
      notificationSettings: NotificationSettings(
        title: alarmTitle,
        body: alarmContent,
        stopButton: stopButtonTitle,
        icon: alarmIcon,
      ),
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  static Future<bool> isAlarmActive(int id) async {
    return await Alarm.isRinging(id);
  }
}
