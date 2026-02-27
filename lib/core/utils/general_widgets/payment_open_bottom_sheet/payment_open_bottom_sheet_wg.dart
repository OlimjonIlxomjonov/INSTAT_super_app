import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class PaymentOpenBottomSheetWg extends StatelessWidget {
  const PaymentOpenBottomSheetWg({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildPaymentMethod(AppImages.clickPayment)),
              SizedBox(width: 12),
              Expanded(child: buildPaymentMethod(AppImages.paymePayment)),
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Container buildPaymentMethod(String imagePath) => Container(
    padding: .symmetric(vertical: 15, horizontal: 40),
    decoration: BoxDecoration(
      color: AppColors.greyScale.grey50,
      borderRadius: .circular(16),
      border: .all(color: AppColors.greyScale.grey200),
    ),
    child: Image.asset(imagePath, fit: .cover, height: 32),
  );
}
