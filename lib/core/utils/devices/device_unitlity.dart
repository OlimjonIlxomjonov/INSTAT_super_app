import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

String formatDuration(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;

  if (hours > 0 && minutes > 0) {
    return '$hours soat $minutes daqiqa';
  } else if (hours > 0) {
    return '$hours soat';
  } else {
    return '$minutes daqiqa';
  }
}
