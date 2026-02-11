import 'package:flutter/services.dart';

class TDeviceUtils {
  static Future<void> setStatusBarColor(
    Color color, {
    bool isBright = false,
  }) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: isBright
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }
}
