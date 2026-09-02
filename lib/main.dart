import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:my_template/features/my_bloc_provider.dart';

import 'core/di/service_locator.dart';
import 'features/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSide =
      view.physicalSize.shortestSide / view.devicePixelRatio;
  final isTabletOrLarger = logicalShortestSide >= AppBreakpoints.tablet;

  await SystemChrome.setPreferredOrientations(
    isTabletOrLarger
        ? [] // no restriction
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await setup();
  runApp(MyBlocProvider(child: MyApp()));
  // logger.f(TokenStorageServiceImpl().getAccessToken());
}
