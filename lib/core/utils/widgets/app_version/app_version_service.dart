import 'package:package_info_plus/package_info_plus.dart';

import '../../logger/logger.dart';

/// Ilova versiyasi `pubspec.yaml` dan olinadi — qo'lda yozilgan konstanta
/// versiya ko'tarilganda eskirib qolardi.
class AppVersionService {
  AppVersionService._();

  static PackageInfo? _cached;

  static Future<PackageInfo?> _info() async {
    if (_cached != null) return _cached;
    try {
      return _cached = await PackageInfo.fromPlatform();
    } catch (e) {
      logger.e('PackageInfo error: $e');
      return null;
    }
  }

  /// `1.2.5 (35)` — versiya va build raqami.
  static Future<String?> fullVersion() async {
    final info = await _info();
    if (info == null) return null;
    return '${info.version} (${info.buildNumber})';
  }

  /// `v1.2.5` — drawer pastidagi qisqa ko'rinish uchun.
  static Future<String?> shortVersion() async {
    final info = await _info();
    if (info == null) return null;
    return 'v${info.version}';
  }
}
