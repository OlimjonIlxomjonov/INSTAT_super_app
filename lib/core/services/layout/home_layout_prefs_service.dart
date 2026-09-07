import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bosh sahifa bo'limlarining tartibi va ko'rinishi.
/// [init] main.dart da chaqiriladi — shundan keyin o'qish sinxron bo'ladi,
/// ya'ni home avval default tartibda chiqib keyin sakramaydi.
class HomeLayoutPrefsService {
  static const _orderKey = 'home_section_order';
  static const _hiddenKey = 'home_section_hidden';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// SAQLANGAN TARTIB
  ///
  /// Saqlangan ro'yxat default bilan birlashtiriladi: keyingi relizlarda
  /// yangi bo'lim qo'shilsa, eski foydalanuvchida ham ko'rinadi; olib
  /// tashlangani esa tushib qoladi.
  static List<HomeSectionId> loadOrder() {
    final saved = _prefs?.getStringList(_orderKey);
    if (saved == null || saved.isEmpty) return HomeSectionId.values;

    final resolved = <HomeSectionId>[];
    for (final name in saved) {
      final id = HomeSectionIdX.fromName(name);
      if (id != null && !resolved.contains(id)) resolved.add(id);
    }
    for (final id in HomeSectionId.values) {
      if (!resolved.contains(id)) resolved.add(id);
    }
    return resolved;
  }

  static Set<HomeSectionId> loadHidden() {
    final saved = _prefs?.getStringList(_hiddenKey);
    if (saved == null || saved.isEmpty) return const {};

    final resolved = <HomeSectionId>{};
    for (final name in saved) {
      final id = HomeSectionIdX.fromName(name);
      if (id != null) resolved.add(id);
    }
    return resolved;
  }

  static Future<void> save({
    required List<HomeSectionId> order,
    required Set<HomeSectionId> hidden,
  }) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setStringList(_orderKey, order.map((e) => e.name).toList());
    await prefs.setStringList(_hiddenKey, hidden.map((e) => e.name).toList());
  }

  static Future<void> reset() async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.remove(_orderKey);
    await prefs.remove(_hiddenKey);
  }
}
