import 'package:my_template/core/services/token_storage/jwt_utils.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonWatchStore {
  LessonWatchStore._();

  static String _key(int lessonId) {
    final token = TokenStorageServiceImpl().getAccessToken();
    final userId = token == null ? 0 : (jwtUserId(token) ?? 0);
    return 'lesson_watch_${userId}_$lessonId';
  }

  static Future<Set<int>> load(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key(lessonId)) ?? const [];
    return saved.map(int.tryParse).whereType<int>().toSet();
  }

  static Future<void> save(int lessonId, Set<int> buckets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key(lessonId),
      buckets.map((bucket) => '$bucket').toList(),
    );
  }

  static Future<void> clear(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(lessonId));
  }
}
