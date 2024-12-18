import 'package:permission_handler/permission_handler.dart';

//Push notification action

Future<bool> requestNotificationPermission() async {
  var status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted) {
    status = await Permission.notification.request();
  }
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    var result = await Permission.notification.request();
    if (result.isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }
  return false;
}

//========================================================
