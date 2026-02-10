import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/di/service_locator.dart';
import 'features/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();

  await Hive.initFlutter();
  await Hive.openBox('authBox');
  runApp(MyApp());
}
