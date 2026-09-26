import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesService {
  static const _key = 'recent_searches';
  static const _maxItems = 8;

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static List<String> load() => _prefs?.getStringList(_key) ?? const [];

  static Future<List<String>> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return load();

    final items = List<String>.from(load())
      ..removeWhere((e) => e.toLowerCase() == trimmed.toLowerCase())
      ..insert(0, trimmed);

    final capped = items.take(_maxItems).toList();
    await _prefs?.setStringList(_key, capped);
    return capped;
  }

  static Future<List<String>> remove(String query) async {
    final items = List<String>.from(load())..remove(query);
    await _prefs?.setStringList(_key, items);
    return items;
  }

  static Future<void> clear() async => _prefs?.remove(_key);
}
