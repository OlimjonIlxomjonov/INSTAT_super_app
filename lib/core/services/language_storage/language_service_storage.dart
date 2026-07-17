import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LanguageServiceStorage {
  static const _key = 'selected_language';

  /// Locales with a script variant (e.g. Uzbek Cyrillic) need that script
  /// persisted too, or the app would silently fall back to the base
  /// language's default script on every restart.
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, _encode(locale));
  }

  static Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'uz';
    return _decode(code);
  }

  static String _encode(Locale locale) {
    if (locale.scriptCode != null) {
      return '${locale.languageCode}_${locale.scriptCode}';
    }
    return locale.languageCode;
  }

  static Locale _decode(String code) {
    if (code == 'uz_Cyrl') {
      return const Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl');
    }
    return Locale(code);
  }
}
