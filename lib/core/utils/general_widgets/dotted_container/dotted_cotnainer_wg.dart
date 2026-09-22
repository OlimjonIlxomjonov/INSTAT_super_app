import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';

class DottedContainerWg extends StatelessWidget {
  final VoidCallback? onTap;
  final String? formatsHint;
  final bool hasError;

  const DottedContainerWg({
    super.key,
    this.onTap,
    this.formatsHint,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 1.5,
        color: hasError ? AppColors.iconRed : AppColors.greyScale.grey400,
        radius: .circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: .symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey50,
          borderRadius: .circular(12),
        ),
        child: Column(
          children: [
            Icon(IconlyLight.upload),
            SizedBox(height: 20),
            Text(
              l.selectFileTitle,
              style: AppTextStyles.source.medium(fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              textAlign: .center,
              formatsHint ??
                  'JPEG, PNG, .DOC, .DOCX, .XLS, .XLSX, .PDF, .PPT, .PPTX up to 50 MB.',
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey600,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
              onPressed: onTap,
              child: Text(
                l.chooseButton,
                style: AppTextStyles.source.medium(
                  fontSize: 13,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
