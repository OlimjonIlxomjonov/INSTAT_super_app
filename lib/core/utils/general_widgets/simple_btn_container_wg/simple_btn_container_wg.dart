import 'package:flutter/material.dart';

import '../../app_utils.dart';

class SimpleBtnContainerWg extends StatelessWidget {
  final VoidCallback onFirstTap;
  final VoidCallback? onSecondTap;
  final String onSecondText;

  const SimpleBtnContainerWg({
    super.key,
    required this.onFirstTap,
    this.onSecondTap,
    required this.onSecondText,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const .symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: .only(topRight: .circular(24), topLeft: .circular(24)),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              color: AppColors.greyScale.grey200,
              spreadRadius: 0,
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.transparent,
                  foregroundColor: AppColors.greyScale.grey600,
                ),
                onPressed: onFirstTap,
                child: Text(
                  'Bekor qilish',
                  style: AppTextStyles.source.medium(fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: onSecondTap,
                child: Text(onSecondText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
