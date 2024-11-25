import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingManager {
  static final shared = SettingManager();

  Future<void> saveUserLocale(String languageCode) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString("userLocale", languageCode);
  }

  Future<Locale> getUserLocale() async {
    final storage = await SharedPreferences.getInstance();
    final languageCode = storage.getString("userLocale");

    if (languageCode != null) {
      return Locale(languageCode);
    }

    return const Locale('en', 'US');
  }
}
