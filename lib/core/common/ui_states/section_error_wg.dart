import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';

class SectionErrorWg extends StatelessWidget {
  final String? title;
  final VoidCallback? onRetry;

  const SectionErrorWg({super.key, this.title, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: appW(16), vertical: appH(14)),
      decoration: BoxDecoration(
        color: AppColors.redBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.redFailedTaskCard.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: appW(40),
            height: appW(40),
            decoration: BoxDecoration(
              color: AppColors.redFailedTaskCard.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 22,
              color: AppColors.redFailedTaskCard,
            ),
          ),
          SizedBox(width: appW(12)),
          Expanded(
            child: Text(
              title ?? localization.sectionLoadError,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.medium(
                fontSize: 14,
                color: AppColors.greyScale.grey800,
              ),
            ),
          ),
          if (onRetry != null) ...[
            IconButton(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
                size: 20,
                color: AppColors.redFailedTaskCard,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
