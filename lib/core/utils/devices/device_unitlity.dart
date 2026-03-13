import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TDeviceUtils {
  static Future<void> systemNavigationBar(
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

  static Future<void> setStatusBarColor(
    Color color, {
    bool darkIcons = true,
  }) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,

        // Android: icon color
        statusBarIconBrightness: darkIcons ? Brightness.dark : Brightness.light,

        // iOS: status bar text color (inverted)
        statusBarBrightness: darkIcons ? Brightness.light : Brightness.dark,
      ),
    );
  }
}

abstract class AppPadding {
  static EdgeInsets horizontal20x() => .symmetric(horizontal: 20);

  static EdgeInsets hAndV20x20() => .symmetric(horizontal: 20, vertical: 20);
}
