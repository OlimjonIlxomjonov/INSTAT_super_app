import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/onboarding/screens/components/log_in_options_component.dart';

class LogInOptionsPage extends StatelessWidget {
  const LogInOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TDeviceUtils.lightStatusBarIcons,
      child: Scaffold(
        backgroundColor: AppColors.splashBackgroundColor,
        body: LogInOptionsComponent(),
      ),
    );
  }
}
