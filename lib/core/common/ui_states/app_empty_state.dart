import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

/// A reusable empty state widget with two modes:
///
/// - **Default (full-page):** Lottie illustration + title + optional subtitle
///   + optional CTA button. Use inside `SliverFillRemaining` or `Center`.
///
/// - **Compact:** A slim rounded card with an icon + text. Use inline under
///   section headers in scrollable lists.
///
/// ```dart
/// // Full-page
/// AppEmptyState(
///   title: 'Hali kurs boshlanmagan',
///   subtitle: 'Kurslarni topib o\'rganishni boshlang!',
///   buttonLabel: 'Kurslarni ko\'rish',
///   onAction: () => navigate(),
/// )
///
/// // Compact inline
/// AppEmptyState.compact(
///   title: 'Hech qanday so\'rovlar mavjud emas',
///   icon: IconlyLight.document,
/// )
/// ```
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onAction;
  final String? animationAsset;
  final double illustrationSize;
  final bool _compact;
  final IconData? _compactIcon;
  final IconData _compactButtonIcon;

  /// Full-page empty state with Lottie animation + title + optional CTA.
  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onAction,
    this.animationAsset,
    this.illustrationSize = 180,
  })  : _compact = false,
        _compactIcon = null,
        _compactButtonIcon = Icons.arrow_forward_rounded;

  /// Compact inline empty state — slim card with icon + text.
  /// Fits naturally under section headers in scrollable lists.
  const AppEmptyState.compact({
    super.key,
    required this.title,
    IconData? icon,
    this.buttonLabel,
    this.onAction,
  })  : _compact = true,
        _compactIcon = icon,
        _compactButtonIcon = Icons.arrow_forward_rounded,
        subtitle = null,
        animationAsset = null,
        illustrationSize = 180;

  @override
  Widget build(BuildContext context) {
    return _compact ? _buildCompact(context) : _buildFull();
  }

  // ─────────────────────── COMPACT MODE ───────────────────────

  Widget _buildCompact(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appW(20)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: appW(16), vertical: appH(16)),
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ── Icon circle ──
            Container(
              width: appW(40),
              height: appW(40),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _compactIcon ?? Icons.inbox_rounded,
                size: 20,
                color: AppColors.greyScale.grey500,
              ),
            ),

            SizedBox(width: appW(12)),

            // ── Text ──
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.source.regular(
                  fontSize: 13,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ),

            // ── Optional action ──
            if (buttonLabel != null && onAction != null) ...[
              SizedBox(width: appW(8)),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appW(12),
                    vertical: appH(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonLabel!,
                    style: AppTextStyles.source.medium(
                      fontSize: 12,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Icon(
                _compactButtonIcon,
                size: 16,
                color: AppColors.greyScale.grey400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─────────────────────── FULL MODE ───────────────────────

  Widget _buildFull() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appW(32)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Illustration ──
          SizedBox(
            width: appW(illustrationSize),
            height: appH(illustrationSize),
            child: Lottie.asset(
              animationAsset ?? AppAnimations.emptyState,
              repeat: false,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: appH(20)),

          // ── Title ──
          Text(
            title,
            style: AppTextStyles.source.semiBold(
              fontSize: 18,
              color: AppColors.greyScale.grey900,
            ),
            textAlign: TextAlign.center,
          ),

          if (subtitle != null) ...[
            SizedBox(height: appH(8)),
            Text(
              subtitle!,
              style: AppTextStyles.source.regular(
                fontSize: 14,
                color: AppColors.greyScale.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (buttonLabel != null && onAction != null) ...[
            SizedBox(height: appH(24)),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: appH(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onAction,
                icon: const Icon(Icons.explore_outlined, size: 20),
                label: Text(
                  buttonLabel!,
                  style: AppTextStyles.source.medium(
                    fontSize: 15,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
