import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:my_template/features/auth/presentation/widgets/continue_with_options.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';

class LogInOptionsComponent extends StatefulWidget {
  const LogInOptionsComponent({super.key});

  @override
  State<LogInOptionsComponent> createState() => _LogInOptionsComponentState();
}

class _LogInOptionsComponentState extends State<LogInOptionsComponent> {
  bool isConnectedToInternet = false;
  StreamSubscription? _internetStreamSubs;
  final screenHeight = AppResponsiveness.screenHeight;

  /// orientation check
  final Orientation oPortrait = Orientation.portrait;

  void _openPage() {
    if (!isConnectedToInternet) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text('Hey!'),
          content: Text('Please check the internet connection and try again'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                AppRoute.open(HomePage());
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      AppRoute.open(HomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _internetStreamSubs = InternetConnection().onStatusChange.listen((event) {
      logger.f(event);
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    _internetStreamSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    // final bool isTablet = Responsive.isTablet(context);

    return SizedBox(
      width: double.infinity,
      height: Responsive.isMobile(context) ? screenHeight / 1.6 : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
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
                  fontSize: 16,
                  color: AppColors.greyScale.grey600,
                ),
              ),
              SizedBox(height: appH(32)),

              /// LOG IN WITH ONE ID
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openPage,
                  child: SvgPicture.asset(AppVectors.oneIdLogo),
                ),
              ),

              SizedBox(height: 32),

              /// DIVIDER -OR-
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

              /// Apple Account
              ContinueWithOptions(
                iconPath: AppVectors.appleLogo,
                onTap: () {
                  // AppRoute.go(MyBook());
                },
                continueWithText: localization.continueWithApple,
              ),

              /// Google Account
              ContinueWithOptions(
                iconPath: AppVectors.googleLogo,
                onTap: () {},
                continueWithText: localization.continueWithGoogle,
              ),

              /// FaceBook Account
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
