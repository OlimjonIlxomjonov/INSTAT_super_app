import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:my_template/features/onboarding/screens/components/log_in_options_component.dart';

class LogInOptionsPage extends StatefulWidget {
  const LogInOptionsPage({super.key});

  @override
  State<LogInOptionsPage> createState() => _LogInOptionsPageState();
}

class _LogInOptionsPageState extends State<LogInOptionsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage(const AssetImage(AppImages.onboardingLogIn), context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = AppResponsiveness.screenHeight;
    TDeviceUtils.systemNavigationBar(AppColors.white);

    return Scaffold(
      // backgroundColor: AppColors.primaryColor.withValues(alpha: 0.8),
      extendBodyBehindAppBar: true,
      // body: Stack(
      //   children: [
      //     ConstrainedBox(
      //       constraints: BoxConstraints(minWidth: double.infinity),
      //       child: SvgPicture.asset(AppImages.onboardingLogIn, fit: .cover),
      //     ),
      //     Positioned(
      //       left: 0,
      //       right: 0,
      //       top: screenHeight / 7,
      //       child: SvgPicture.asset(AppVectors.mainAppLogo),
      //     ),
      //   ],
      // ),
      // body: SvgPicture.asset(AppVectors.mainAppLogo),
      bottomSheet: LogInOptionsComponent(),
    );
  }
}
