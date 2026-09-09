import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class VacancySectionCardWg extends StatelessWidget {
  final String title;
  final Widget child;

  const VacancySectionCardWg({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VacancySectionTitleWg(title: title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class VacancySectionTitleWg extends StatelessWidget {
  final String title;

  const VacancySectionTitleWg({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.source.semiBold(fontSize: 16));
  }
}
