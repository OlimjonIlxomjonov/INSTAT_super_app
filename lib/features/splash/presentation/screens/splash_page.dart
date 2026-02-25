import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/onboarding/screens/onboarding_page.dart';
import 'package:my_template/features/splash/presentation/screens/grid_background_painter.dart';

import '../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../core/utils/devices/device_unitlity.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _timerDirection();
  }

  Future<void> _timerDirection() async {
    Future.delayed(Duration(seconds: 2), () {
      AppRoute.open(OnboardingPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.systemNavigationBar(
      AppColors.splashBackgroundColor,
      isBright: true,
    );
    TDeviceUtils.setStatusBarColor(AppColors.transparent, darkIcons: true);

    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GridBackgroundPainter(
                backgroundColor: AppColors.splashBackgroundColor,
                lineColor: Colors.white,
                cellSize: appW(100),
                majorEvery: 4,
                minorOpacity: 0.06,
                majorOpacity: 0.12,
                strokeWidth: 1,
              ),
            ),
          ),

          //  logo
          Center(child: SvgPicture.asset(AppVectors.mainAppLogo)),

          //  bottom text
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: appH(20)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'A better eLearning platform',
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
