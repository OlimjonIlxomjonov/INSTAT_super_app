import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/l10n/l10n.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/language_storage/language_service_storage.dart';
import 'package:my_template/core/streams/general_streams.dart';
import 'package:my_template/core/utils/theme/app_theme.dart';
import 'package:my_template/features/splash/presentation/screens/splash_page.dart';

import '../core/utils/responsiveness/app_responsiveness.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _loadLanguage();
    super.initState();
  }

  Future<void> _loadLanguage() async {
    final locale = await LanguageServiceStorage.loadLocale();
    GeneralStream.languageStream.add(locale);
  }

  @override
  void dispose() {
    GeneralStream.languageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppResponsiveness.init(context);
    return StreamBuilder<Locale>(
      stream: GeneralStream.languageStream.stream,
      builder: (context, snapshot) {
        return MaterialApp(
          // builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          navigatorKey: AppRoute.navigatorKey,
          theme: TAppTheme.lightTheme,
          supportedLocales: L10n.all,
          locale: snapshot.data,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashPage(),
        );
      },
    );
  }
}
