import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class ServerErrorState extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  final int? statusCode;

  const ServerErrorState({
    super.key,
    this.onRetry,
    this.message,
    this.statusCode,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMaintenance = statusCode == 502 || statusCode == 503;
    final String title = isMaintenance
        ? 'Serverda texnik ishlar ketmoqda'
        : 'Server bilan bog\'lanishda xatolik';
    final String subtitle =
        message ?? 'Iltimos, birozdan so\'ng qayta urinib ko\'ring';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                AppAnimations.errorPage,
                repeat: false,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.regular(
                color: AppColors.greyScale.grey600,
                fontSize: 14,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Qayta urinish'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
