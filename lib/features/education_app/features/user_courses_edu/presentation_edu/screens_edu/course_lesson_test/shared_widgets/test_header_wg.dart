import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';

class TestHeaderWg extends StatelessWidget {
  final double progress;

  const TestHeaderWg({super.key, required this.progress});

  void _showDialog(BuildContext context) {
    showConfirmDialog(
      context,
      title: 'Chiqishni xohlaysizmi?',
      description: "Kiritilgan ma'lumotlar saqlanip qolinmaydi!",
      onConfirm: () => AppRoute.close(),
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
