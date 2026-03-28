import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class LostInternetConnectionState extends StatelessWidget {
  final VoidCallback? onRetry;

  const LostInternetConnectionState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: Lottie.asset(
              AppAnimations.lostInternetConnectionState,
              repeat: false,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text('Internet aloqasi yo\'q', style: CustomTextStyles.h3),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Qayta urinish'),
            ),
          ],
        ],
      ),
    );
  }
}
