import 'package:alarm/alarm.dart';

class AlarmNotification {
  Future<void> createAlarm(String alarmTitle, String alarmContent,
      String alarmIcon, String stopButtonTitle) async {
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: DateTime.now().add(const Duration(seconds: 10)),
      assetAudioPath: 'assets/images/logo.png',
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

  Future<void> stopAlarm() async {
    await Alarm.stop(1);
  }

  Future<bool> isAlarmActive() async {
    return await Alarm.isRinging(1);
  }
}
