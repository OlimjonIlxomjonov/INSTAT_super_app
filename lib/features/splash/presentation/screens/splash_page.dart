import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';
import 'package:my_template/features/onboarding/screens/onboarding_page.dart';
import 'package:my_template/features/splash/presentation/screens/grid_background_painter.dart';
import 'package:my_template/features/splash/presentation/screens/no_internet_page.dart';

import '../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../core/utils/devices/device_unitlity.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final GridBackgroundPainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = GridBackgroundPainter(
      backgroundColor: AppColors.splashBackgroundColor,
      lineColor: Colors.white,
      cellSize: appW(100),
      majorEvery: 4,
      minorOpacity: 0.06,
      majorOpacity: 0.12,
      strokeWidth: 1,
    );
    _timerDirection();
  }

  Future<void> _timerDirection() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await TokenStorageServiceImpl().getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    // Determine where the user should ultimately go.
    final destination =
        isLoggedIn ? const HomePage() : const OnboardingPage();

    // Check REAL internet access (pings actual URLs, catches WiFi-but-no-internet).
    final hasInternet = await InternetConnection().hasInternetAccess;
    if (!mounted) return;

    if (hasInternet) {
      AppRoute.open(destination);
    } else {
      // Show the no-internet gate; it auto-navigates to [destination] when
      // connectivity is restored.
      AppRoute.open(NoInternetPage(destination: destination));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _painter)),

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
