import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/auth/presentation/widgets/continue_with_options.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';

class LogInOptionsPage extends StatefulWidget {
  const LogInOptionsPage({super.key});

  @override
  State<LogInOptionsPage> createState() => _LogInOptionsPageState();
}

class _LogInOptionsPageState extends State<LogInOptionsPage> {
  bool isConnectedToInternet = false;
  StreamSubscription? _internetStreamSubs;

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
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
  }

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
                Navigator.of(context).pop();
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
  void dispose() {
    _internetStreamSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppResponsiveness.screenHeight;
    TDeviceUtils.systemNavigationBar(AppColors.white);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Image.asset(
            AppImages.onboardingLogIn,
            fit: BoxFit.cover,
            height: screenHeight / 2.5,
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: screenHeight / 1.6,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: appH(20),
            horizontal: appW(20),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                AppStrings.getStart,
                style: AppTextStyles.source.bold(fontSize: 22),
              ),
              SizedBox(height: appH(8)),
              Text(
                AppStrings.registerOrEnterTheSystem,
                style: AppTextStyles.source.regular(
                  fontSize: 13,
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

              SizedBox(height: appH(32)),

              /// DIVIDER -OR-
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.greyScale.grey400)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: appW(12)),
                    child: Text(
                      'Yoki',
                      style: AppTextStyles.source.regular(
                        fontSize: 13,
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
                icon: Icons.apple,
                onTap: () {},
                continueWithText: 'Apple akkount orqali kirish',
              ),

              /// Google Account
              ContinueWithOptions(
                icon: Icons.g_mobiledata,
                onTap: () {},
                continueWithText: 'Google akkount orqali kirish',
              ),

              /// FaceBook Account
              ContinueWithOptions(
                icon: Icons.facebook,
                onTap: () {},
                continueWithText: 'Facebook akkount orqali kirish',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
