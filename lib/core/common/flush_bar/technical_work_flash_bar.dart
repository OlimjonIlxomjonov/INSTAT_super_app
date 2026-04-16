import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

void technicalWorkFlushBar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: AppTextStyles.source.semiBold(
        color: AppColors.yellow,
        fontSize: 16,
      ),
    ),
    backgroundColor: AppColors.white.withValues(alpha: 0.8),
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    icon: Lottie.asset(AppAnimations.workFuv, repeat: false),
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}
