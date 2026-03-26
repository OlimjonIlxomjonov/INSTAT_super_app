import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 170,
          child: Lottie.asset(
            AppAnimations.emptyState,
            repeat: false,
            fit: BoxFit.contain,
          ),
        ),
        Text(message, style: CustomTextStyles.h3),
      ],
    );
  }
}
