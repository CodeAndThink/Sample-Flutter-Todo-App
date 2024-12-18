import 'package:todo_app/common/permission/permissions.dart';

class PermissionManager {
  static final shared = PermissionManager();
  bool _notificationPermission = false;
  bool get notificationPermission => _notificationPermission;

  PermissionManager();

  void notificationPermissionRequest() async {
    _notificationPermission = await requestNotificationPermission();
  }
}
