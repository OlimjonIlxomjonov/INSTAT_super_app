import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

/// Shows a custom-styled confirmation dialog (icon badge + two stacked
/// buttons: a destructive confirm action and a cancel action).
///
/// Renders identically on iOS and Android — deliberately not
/// [AlertDialog.adaptive], so the design stays consistent across platforms.
Future<void> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? description,
  String confirmText = 'Chiqish',
  String cancelText = 'Qolish',
  required VoidCallback onConfirm,
}) {
  return _showDialogShell(
    context,
    icon: Icons.warning_rounded,
    iconColor: AppColors.iconRed,
    iconBackground: AppColors.iconRedBackground,
    title: title,
    description: description,
    buttons: (ctx) => [
      _DialogButton(
        text: confirmText,
        backgroundColor: AppColors.iconRed,
        textColor: AppColors.white,
        onPressed: () {
          Navigator.pop(ctx);
          onConfirm();
        },
      ),
      const SizedBox(height: 10),
      _DialogButton(
        text: cancelText,
        textColor: AppColors.greyScale.grey700,
        onPressed: () => Navigator.pop(ctx),
      ),
    ],
  );
}

/// Shows a custom-styled info/success dialog (icon badge + a single button).
///
/// Renders identically on iOS and Android — deliberately not
/// [AlertDialog.adaptive], so the design stays consistent across platforms.
Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  String? description,
  String buttonText = 'Yaxshi',
  VoidCallback? onDismiss,
  bool barrierDismissible = false,
}) {
  return _showDialogShell(
    context,
    icon: Icons.check_circle_rounded,
    iconColor: AppColors.iconGreen,
    iconBackground: AppColors.iconGreenBackground,
    title: title,
    description: description,
    barrierDismissible: barrierDismissible,
    buttons: (ctx) => [
      _DialogButton(
        text: buttonText,
        backgroundColor: AppColors.iconGreen,
        textColor: AppColors.white,
        onPressed: () {
          Navigator.pop(ctx);
          onDismiss?.call();
        },
      ),
    ],
  );
}

Future<void> _showDialogShell(
  BuildContext context, {
  required IconData icon,
  required Color iconColor,
  required Color iconBackground,
  required String title,
  String? description,
  required List<Widget> Function(BuildContext ctx) buttons,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) => Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: CustomTextStyles.h2,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: CustomTextStyles.h4,
              ),
            ],
            const SizedBox(height: 24),
            ...buttons(ctx),
          ],
        ),
      ),
    ),
  );
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.text,
    this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: backgroundColor != null
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(text, style: CustomTextStyles.h3.copyWith(color: textColor)),
            )
          : TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(text, style: CustomTextStyles.h3),
            ),
    );
  }
}
