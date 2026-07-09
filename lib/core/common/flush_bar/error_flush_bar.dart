import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

Flushbar? _currentFlushBar;

void errorFlushBar(BuildContext context, String message) {
  _currentFlushBar?.dismiss();

  _currentFlushBar = Flushbar(
    messageText: Text(
      message,
      style: AppTextStyles.source.semiBold(
        color: AppColors.white,
        fontSize: 16,
      ),
    ),
    backgroundColor: AppColors.redFailedTaskCard.withValues(alpha: 0.8),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    icon: Lottie.asset(AppAnimations.errorState, repeat: false),
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
    borderRadius: BorderRadius.circular(8),
  );

  _currentFlushBar!.show(context);
}
