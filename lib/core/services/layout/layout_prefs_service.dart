import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LayoutPrefsService {
  static const _prefix = 'layout_';

  static Future<CoursesLayout> load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('$_prefix$key');
    return saved == 'list' ? CoursesLayout.list : CoursesLayout.grid;
  }

  static Future<void> save(String key, CoursesLayout layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix$key',
      layout == CoursesLayout.list ? 'list' : 'grid',
    );
  }
}
