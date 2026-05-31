import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

/// A reusable full-screen overlay that blocks interaction while a file
/// is being downloaded and opened. Works as a Stack child.
///
/// Usage: wrap your page body in a [Stack] and conditionally show this widget
/// using a [ValueListenableBuilder] or [BlocBuilder].
class FileOpeningOverlayWg extends StatelessWidget {
  final String title;
  final String subtitle;

  const FileOpeningOverlayWg({
    super.key,
    this.title = 'Fayl ochilmoqda...',
    this.subtitle = 'Iltimos, kuting',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: Center(
        child: Card(
          color: AppColors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: AppTextStyles.source.medium(
                    fontSize: 16,
                    color: AppColors.greyScale.grey800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
