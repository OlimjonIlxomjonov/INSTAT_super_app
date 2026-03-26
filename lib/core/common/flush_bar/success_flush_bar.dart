import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

void successFlushBar(BuildContext context, String message) {
  Flushbar(
    messageText: Text(
      message,
      style: AppTextStyles.source.semiBold(
        color: AppColors.white,
        fontSize: 16,
      ),
    ),
    backgroundColor: Colors.green.withValues(alpha: 0.5),
    duration: const Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    // icon: Container(
    //   padding: const EdgeInsets.all(4),
    //   decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
    //   child: Icon(Icons.check, color: AppColors.green),
    // ),
    icon: Lottie.asset(AppAnimations.successCheck, repeat: false),
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}
