import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

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

abstract class AppPadding {
  static EdgeInsets horizontal20x() => .symmetric(horizontal: appW(20));

  static EdgeInsets hAndV20x20() =>
      .symmetric(horizontal: appW(20), vertical: appH(20));
}
