import 'package:flutter/cupertino.dart';

import 'create_route.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void close() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState!.pop();
    }
  }

  static void go(Widget page) {
    navigatorKey.currentState!.push(createRoute(page));
  }

  static void open(Widget page) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      createRoute(page),
      (Route<dynamic> route) => false,
    );
  }

  static void replace(Widget page) {
    navigatorKey.currentState!.pushReplacement(createRoute(page));
  }
}
