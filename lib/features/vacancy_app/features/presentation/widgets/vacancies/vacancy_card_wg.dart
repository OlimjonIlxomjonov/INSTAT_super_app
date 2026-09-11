import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_detailed_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_row_item_wg.dart';

import '../../../../../../../../core/utils/app_utils.dart';

class VacancyCardWg extends StatelessWidget {
  const VacancyCardWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      margin: const .symmetric(horizontal: 20),
      padding: const .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          //! 1
          Row(
            children: [
              Text(
                localization.publishedDateLabel,
                style: AppTextStyles.source.medium(
                  fontSize: 12,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '12.01.2001 - 31.01.2001',
                style: AppTextStyles.source.medium(fontSize: 12),
              ),
              const Spacer(),
              Icon(FlutterRemix.bookmark_line, size: 21),
            ],
          ),
          const SizedBox(height: 6),
          //! 2
          Text(
            'Senior Frontend Developer',
            style: AppTextStyles.source.medium(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text('Operator', style: AppTextStyles.source.regular(fontSize: 12)),
          const SizedBox(height: 12),
          //! 3
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.money_dollar_circle_line,
            title: localization.salaryLabel,
            trailing: '25.000.000 so’m',
          ),
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.map_pin_line,
            title: localization.workplaceLabel,
            trailing: 'Toshkent shahri',
          ),
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.team_line,
            title: localization.vacantPlacesLabel,
            trailing: '12',
          ),
          const SizedBox(height: 8),
          //! 4
          Row(
            children: [
              _customContainer('To’liq stavka'),
              const SizedBox(width: 12),
              _customContainer('Ish staji 3-4 yil '),
            ],
          ),
          const SizedBox(height: 12),
          //! 5
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    openMiniAppSheetFamily(
                      context,
                      child: VacancyDetailedWg(),
                      showHandler: false,
                    );
                  },
                  child: Text(localization.moreDetails),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _customContainer(String title) {
    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: .circular(6),
        color: AppColors.greyScale.grey50,
      ),
      child: Text(
        '• $title',
        style: AppTextStyles.source.medium(
          fontSize: 12,
          color: AppColors.greyScale.grey600,
        ),
      ),
    );
  }
}
