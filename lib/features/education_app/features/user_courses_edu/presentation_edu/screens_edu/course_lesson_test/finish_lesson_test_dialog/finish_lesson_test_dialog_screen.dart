import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

Future<void> finishLessonTestDialogScreen(
  BuildContext context, {
  required Widget header,
  body,
  required String title,
  subTitle,
  required List<Widget> actions,
  required ConfettiController confettiController,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return Stack(
        children: [
          AlertDialog.adaptive(
            backgroundColor: AppColors.white,
            title: Column(
              children: [
                header,
                SizedBox(height: appH(16)),
                Text(title, style: AppTextStyles.source.medium(fontSize: 22)),
                SizedBox(height: appH(12)),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.source.regular(
                    fontSize: 15,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
            content: body,
            actions: actions,
          ),
          Align(
            alignment: .topCenter,
            child: ConfettiWidget(
              emissionFrequency: 0.08,
              blastDirectionality: .explosive,
              confettiController: confettiController,
              shouldLoop: false,
              colors: [AppColors.primaryColor, AppColors.orange500],
            ),
          ),
        ],
      );
    },
  );
}
