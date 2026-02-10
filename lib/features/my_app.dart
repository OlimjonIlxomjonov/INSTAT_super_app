import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/theme/app_theme.dart';
import 'package:my_template/features/splash/presentation/screens/splash_page.dart';

import '../core/utils/responsiveness/app_responsiveness.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppResponsiveness.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRoute.navigatorKey,
      theme: TAppTheme.lightTheme,
      home: SplashPage(),
    );
  }
}
