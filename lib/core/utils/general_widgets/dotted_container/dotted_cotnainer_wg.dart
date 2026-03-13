import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

class DottedContainerWg extends StatelessWidget {
  const DottedContainerWg({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [10, 5],
        strokeWidth: 1.5,
        color: AppColors.greyScale.grey400,
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
              'Choose a file or drag & drop it here.',
              style: AppTextStyles.source.medium(fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              'JPEG, PNG, PDF, and MP4 formats, up to 50 MB.',
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey600,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
              onPressed: () {},
              child: Text(
                'Tanlash',
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
