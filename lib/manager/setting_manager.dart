import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingManager {
  static final shared = SettingManager();

  Future<void> saveUserLocale(String languageCode, String countryCode) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString("userLocale", "$languageCode-$countryCode");
  }

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
