import 'package:flutter/material.dart';

import 'def_text_style.dart';

abstract class AppTextStyles {
  static final DefTextStyle source = DefTextStyle();

  TextStyle bold({Color color, required double fontSize});

  TextStyle semiBold({Color color, required double fontSize});

  TextStyle medium({Color color, required double fontSize});

  TextStyle regular({Color color, required double fontSize});
}
