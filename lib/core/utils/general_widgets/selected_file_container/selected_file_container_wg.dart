import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/utils/app_utils.dart';

class SelectedFileContainerWg extends StatelessWidget {
  final String? fileName;
  final String? fileSize;
  final VoidCallback? onTap;

  const SelectedFileContainerWg({
    super.key,
    this.fileName,
    this.fileSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(AppVectors.pdfIcon),
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName ?? 'Tahlil, taqqoslash va prognozlash',
                    style: AppTextStyles.source.medium(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    fileSize ?? '3.4 MB',
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
