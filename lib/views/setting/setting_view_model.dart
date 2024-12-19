import 'package:flutter/material.dart';
import 'package:todo_app/configs/configs.dart';
import 'package:todo_app/manager/auth_manager.dart';
import 'package:todo_app/manager/setting_manager.dart';
import 'package:todo_app/network/api_provider.dart';

class SettingViewModel extends ChangeNotifier {
  //MARK: Properties

  Locale _currentLocale = Configs.defaultLocale;
  Locale get currentLocale => _currentLocale;

  bool _isNotiEnable = false;
  bool get isNotiEnable => _isNotiEnable;

  late ApiProvider _provider;
  late AuthManager _authManager;

  

  //MARK: Constructor

  SettingViewModel(ApiProvider provider, AuthManager authManager) {
    _provider = provider;
    _authManager = authManager;
    _setLastLocale();
  }

  //MARK: Public Functions

  //Function change the locale of app
  void toggleLocale() {
    _currentLocale =
        _currentLocale.languageCode == Configs.defaultLocale.languageCode
            ? Configs.viLocale
            : Configs.defaultLocale;
    SettingManager.shared.saveUserLocale(
        _currentLocale.languageCode, _currentLocale.countryCode!);
    notifyListeners();
  }

  //Function allow or ban notification
  void toggleNoti() {
    _isNotiEnable = !_isNotiEnable;
    notifyListeners();
  }

  //Function for signout
  void signout() {
    _provider.signOut();
    _authManager.removeUserToken();
  }

  //MARK: Private Functions

  

  //Function get last locale set by user
  void _setLastLocale() async {
    _currentLocale = await SettingManager.shared.getUserLocale();
    notifyListeners();
  }
}
