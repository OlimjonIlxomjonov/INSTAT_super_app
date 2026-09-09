import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

class VacancyBulletSectionWg extends StatelessWidget {
  final String title;
  final List<String> items;

  const VacancyBulletSectionWg({
    super.key,
    required this.title,
    required this.items,
  });

  static const double _dotSize = 5;

  @override
  Widget build(BuildContext context) {
    final itemStyle = AppTextStyles.source.regular(
      fontSize: 14,
      color: AppColors.greyScale.grey600,
    );
    final dotTopOffset = ((itemStyle.fontSize ?? 14) * 1.4 - _dotSize) / 2;

    return VacancySectionCardWg(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: dotTopOffset),
                    child: Container(
                      width: _dotSize,
                      height: _dotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(items[i], style: itemStyle)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
