import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/my_bloc_provider.dart';

import 'core/di/service_locator.dart';
import 'features/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setup();
  runApp(MyBlocProvider(child: MyApp()));
  logger.f(TokenStorageServiceImpl().getAccessToken());
}
