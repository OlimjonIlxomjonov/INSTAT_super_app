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

    return Responsive(
      mobile: Scaffold(
        backgroundColor: AppColors.primaryColor.withValues(alpha: 0.8),
        extendBodyBehindAppBar: true,
        // body: Image.asset(
        //   AppImages.onboardingLogIn,
        //   fit: BoxFit.cover,
        //   height: screenHeight / 2.5,
        // ),
        body: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: SvgPicture.asset(AppImages.onboardingLogIn, fit: .cover),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: screenHeight / 7,
              child: SvgPicture.asset(AppVectors.mainAppLogo),
            ),
          ],
        ),
        bottomSheet: LogInOptionsComponent(),
      ),
      tablet: Scaffold(
        body: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            return isPortrait
                /// MIDDLE TRANSPARENT POSITION
                ? Stack(
                    children: [
                      // Image.asset(
                      //   AppImages.onboardingLogIn,
                      //   fit: BoxFit.cover,
                      //   width: double.infinity,
                      //   height: double.infinity,
                      // ),
                      SvgPicture.asset(AppImages.onboardingLogIn),
                      Align(
                        alignment: .center,
                        child: Container(
                          constraints: BoxConstraints(
                            // maxHeight: MediaQuery.sizeOf(context).height / 1.5,
                            maxWidth: MediaQuery.sizeOf(context).width / 1.1,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: .circular(20),
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                          child: LogInOptionsComponent(),
                        ),
                      ),
                    ],
                  )
                /// LEFT AND RIGHT POSITIONED
                : Row(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          AppImages.onboardingLogIn,
                          width: double.infinity,
                          height: double.infinity,
                          fit: .cover,
                        ),
                      ),
                      Expanded(child: LogInOptionsComponent()),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
