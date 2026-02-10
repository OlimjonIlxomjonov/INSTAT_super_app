import 'package:flutter/material.dart';

import '../../../utils/responsiveness/app_responsiveness.dart';
import 'app_text_style.dart';

class DefTextStyle extends AppTextStyles {
  @override
  TextStyle bold({Color? color, required double fontSize}) => TextStyle(
    fontSize: AppResponsiveness.heigh(fontSize),
    fontWeight: FontWeight.bold,
    color: color,
  );

  @override
  TextStyle semiBold({Color? color, required double fontSize}) => TextStyle(
    fontSize: AppResponsiveness.heigh(fontSize),
    fontWeight: FontWeight.w600,
    color: color,
  );

  @override
  TextStyle medium({Color? color, required double fontSize}) => TextStyle(
    fontSize: AppResponsiveness.heigh(fontSize),
    fontWeight: FontWeight.w500,
    color: color,
  );

  @override
  TextStyle regular({Color? color, required double fontSize}) => TextStyle(
    fontSize: AppResponsiveness.heigh(fontSize),
    fontWeight: FontWeight.w400,
    color: color,
  );
}
