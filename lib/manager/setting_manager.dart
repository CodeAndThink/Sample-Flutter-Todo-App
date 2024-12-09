import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingManager {
  static final shared = SettingManager();

  //Save current locale setting by user
  Future<void> saveUserLocale(String languageCode, String countryCode) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString("userLocale", "$languageCode-$countryCode");
  }

  //Get current locale saving of the last setting
  Future<Locale> getUserLocale() async {
    final storage = await SharedPreferences.getInstance();
    final languageCode = storage.getString("userLocale");

    if (languageCode != null) {
      final langCode = languageCode.split('-')[0];
      final counCode = languageCode.split('-')[1];

      return Locale(langCode, counCode);
    }

    return const Locale('en', 'US');
  }
}
