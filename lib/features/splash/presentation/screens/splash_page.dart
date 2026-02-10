import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/features/app_bottom_nav_bar.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_page.dart';

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
      AppRoute.open(LogInPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.setStatusBarColor(AppColors.white);
    return Scaffold(body: Center(child: Text('Redircting...')));
  }
}
