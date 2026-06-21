import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';

import '../../../../../../../../core/utils/constants/custom_text_styles/custom_text_styles.dart';

class TestHeaderWg extends StatelessWidget {
  final double progress;

  const TestHeaderWg({super.key, required this.progress});

  void _showDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog.adaptive(
          title: Text('Chiqishni xohlaysizmi?', style: CustomTextStyles.h2),
          content: Text(
            "Kiritilgan ma'lumotlar saqlanip qolinmaydi!",
            style: CustomTextStyles.h4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Qolish'),
            ),
            TextButton(
              onPressed: () {
                AppRoute.close();
                Navigator.pop(ctx);
              },
              child: Text('Chiqish', style: TextStyle(color: AppColors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      sliver: SliverAppBar(
        floating: true,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: LinearProgressIndicator(
          value: progress,
          minHeight: 16,
          borderRadius: BorderRadius.circular(35),
          color: AppColors.primaryColor,
          backgroundColor: AppColors.greyScale.grey200,
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(color: AppColors.greyScale.grey200),
              ),
            ),
            onPressed: () => _showDialog(context),
            icon: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }
}
