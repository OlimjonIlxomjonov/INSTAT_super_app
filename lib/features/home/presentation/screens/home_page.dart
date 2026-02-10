import 'package:flutter/material.dart';

import '../../../../core/utils/constants/colors/app_colors.dart';
import '../../../../core/utils/devices/device_unitlity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.setStatusBarColor(AppColors.white);

    return Center(child: Text('HOME PAGE'));
  }
}
