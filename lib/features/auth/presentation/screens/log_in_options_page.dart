import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
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
  Widget build(BuildContext context) {
    final screenHeight = AppResponsiveness.screenHeight;
    TDeviceUtils.systemNavigationBar(AppColors.white);

    return Responsive(
      mobile: Scaffold(
        extendBodyBehindAppBar: true,
        body: Image.asset(
          AppImages.onboardingLogIn,
          fit: BoxFit.cover,
          height: screenHeight / 2.5,
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
                      Image.asset(
                        AppImages.onboardingLogIn,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Align(
                        alignment: .center,
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height / 1.5,
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
                        child: Image.asset(
                          AppImages.onboardingLogIn,
                          fit: BoxFit.cover,
                          height: double.infinity,
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
