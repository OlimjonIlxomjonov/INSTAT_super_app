import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class LessonNavBarWg extends StatelessWidget {
  final bool showPrevious;
  final bool showNext;
  final bool isNextLocked;
  final bool isNextLoading;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const LessonNavBarWg({
    super.key,
    required this.showPrevious,
    required this.showNext,
    required this.isNextLocked,
    required this.isNextLoading,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (!showPrevious && !showNext) return const SizedBox.shrink();
    final localization = AppLocalizations.of(context)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              if (showPrevious)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.greyScale.grey300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: appH(14),
                        horizontal: appW(14),
                      ),
                      textStyle: AppTextStyles.source.medium(fontSize: 14),
                    ),
                    child: _Label(
                      text: localization.previousLessonButton,
                      leading: IconlyLight.arrowLeft2,
                    ),
                  ),
                ),
              if (showPrevious && showNext) const SizedBox(width: 12),
              if (showNext)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: isNextLocked
                        ? ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyScale.grey200,
                            foregroundColor: AppColors.greyScale.grey600,
                            elevation: 0,
                          )
                        : null,
                    child: isNextLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : _Label(
                            text: localization.nextLessonButton,
                            trailing: isNextLocked
                                ? IconlyBold.lock
                                : IconlyLight.arrowRight2,
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final IconData? leading;
  final IconData? trailing;

  const _Label({required this.text, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          Icon(leading, size: 16),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          Icon(trailing, size: 16),
        ],
      ],
    );
  }
}
