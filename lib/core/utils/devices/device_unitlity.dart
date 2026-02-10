import 'package:flutter/services.dart';

class TDeviceUtils {
  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
