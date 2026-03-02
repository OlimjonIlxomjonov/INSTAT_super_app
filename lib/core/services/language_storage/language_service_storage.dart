import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageServiceStorage {
  static const _key = 'selected_language';

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, locale.languageCode);
  }

  static Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'uz';
    return Locale(code);
  }
}
