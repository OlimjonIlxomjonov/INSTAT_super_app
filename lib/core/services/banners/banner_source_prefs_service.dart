import 'package:shared_preferences/shared_preferences.dart';

class BannerSourcePrefsService {
  static const _key = 'use_remote_banners';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static bool loadUseRemote() => _prefs?.getBool(_key) ?? false;

  static Future<void> save(bool useRemote) async {
    await _prefs?.setBool(_key, useRemote);
  }
}
