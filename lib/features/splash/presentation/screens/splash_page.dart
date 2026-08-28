import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/main_app/home/presentation/screens/home_page.dart';
import 'package:my_template/features/onboarding/screens/onboarding_page.dart';
import 'package:my_template/features/splash/presentation/screens/no_internet_page.dart';

import '../../../../core/utils/constants/colors/app_colors.dart';
import 'grid_background_painter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gridController;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _timerDirection();
  }

  @override
  void dispose() {
    // _gridController.dispose();
    super.dispose();
  }

  Future<void> _timerDirection() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = TokenStorageServiceImpl().getAccessToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    final destination = isLoggedIn ? const HomePage() : const OnboardingPage();

    bool hasInternet = true;
    try {
      hasInternet = await InternetConnection().hasInternetAccess.timeout(
        const Duration(seconds: 3),
        onTimeout: () =>
            true, // Proceed to destination instead of freezing or blocking
      );
    } catch (e) {
      hasInternet = true;
    }

    if (!mounted) return;

    if (hasInternet) {
      AppRoute.open(destination);
    } else {
      AppRoute.open(NoInternetPage(destination: destination));
    }
    // logger.f("Is internet connected: $hasInternet");
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, _) {
                return CustomPaint(
                  painter: GridBackgroundPainter(
                    backgroundColor: AppColors.splashBackgroundColor,
                    lineColor: Colors.white,
                    cellSize: appW(100),
                    majorEvery: 4,
                    minorOpacity: 0.06,
                    majorOpacity: 0.12,
                    strokeWidth: 1,
                    progress: _gridController.value,
                  ),
                );
              },
            ),
          ),
          //  logo with smooth fade and zoom
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.3 * value),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: SvgPicture.asset(AppVectors.mainAppLogo),
            ),
          ),

          //  bottom text
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: appH(20)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  localization.betterElearningPlatform,
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
