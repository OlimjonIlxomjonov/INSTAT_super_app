import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class EmptyState extends StatelessWidget {
  final String? message;

  const EmptyState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          message != null
              ? Text(message!, style: CustomTextStyles.h3half)
              : SizedBox.shrink(),
          Flexible(
            child: Lottie.asset(
              AppAnimations.emptyState,
              repeat: false,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
