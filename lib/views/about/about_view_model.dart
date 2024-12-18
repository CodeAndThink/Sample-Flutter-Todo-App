import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutViewModel extends ChangeNotifier {
  //MARK: Properties

  String _appVersion = "";
  String get appVersion => _appVersion;

  //MARK: Constructor

  AboutViewModel();

  //MARK: Public Functions

  //Function get app version
  void getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
    } catch (e) {
      _appVersion = "";
    }
    notifyListeners();
  }

  //MARK: Private Functions
}
