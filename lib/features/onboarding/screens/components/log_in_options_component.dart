import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/auth/presentation/widgets/continue_with_options.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';

class LogInOptionsComponent extends StatefulWidget {
  const LogInOptionsComponent({super.key});

  @override
  State<LogInOptionsComponent> createState() => _LogInOptionsComponentState();
}

class _LogInOptionsComponentState extends State<LogInOptionsComponent> {
  final ValueNotifier<bool> _isConnected = ValueNotifier(false);
  StreamSubscription? _internetStreamSubs;
  late final double screenHeight;

  @override
  void initState() {
    super.initState();
    screenHeight = AppResponsiveness.screenHeight;
    _internetStreamSubs = InternetConnection().onStatusChange.listen((event) {
      _isConnected.value = event == InternetStatus.connected;
    });
  }

  @override
  void dispose() {
    _internetStreamSubs?.cancel();
    _isConnected.dispose();
    super.dispose();
  }

  void _openPage() {
    if (!_isConnected.value) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: const Text('Hey!'),
          content: const Text('Please check your internet connection'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AppRoute.open(const HomePage());
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      AppRoute.open(const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: Responsive.isMobile(context) ? screenHeight / 1.6 : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                localization.getStart,
                maxFontSize: 35,
                style: AppTextStyles.source.bold(fontSize: 22),
              ),
              SizedBox(height: appH(8)),
              AutoSizeText(
                localization.registerOrEnterTheSystem,
                maxLines: 2,
                maxFontSize: 22,
                style: AppTextStyles.source.regular(
                  fontSize: 15,
                  color: AppColors.greyScale.grey600,
                ),
              ),
              SizedBox(height: appH(32)),

              ValueListenableBuilder<bool>(
                valueListenable: _isConnected,
                builder: (context, isConnected, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: _openPage, child: child!),
                  );
                },
                child: SvgPicture.asset(AppVectors.oneIdLogo),
              ),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.greyScale.grey400)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: appW(12)),
                    child: AutoSizeText(
                      'Yoki',
                      style: AppTextStyles.source.regular(
                        fontSize: 14,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.greyScale.grey400)),
                ],
              ),
              SizedBox(height: appH(20)),

              ContinueWithOptions(
                iconPath: AppVectors.appleLogo,
                onTap: () {},
                continueWithText: localization.continueWithApple,
              ),
              ContinueWithOptions(
                iconPath: AppVectors.googleLogo,
                onTap: () {},
                continueWithText: localization.continueWithGoogle,
              ),
              ContinueWithOptions(
                iconPath: AppVectors.facebookLogo,
                onTap: () {},
                continueWithText: localization.continueWithFaceBook,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
