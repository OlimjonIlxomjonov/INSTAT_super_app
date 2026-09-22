import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_detailed_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_row_item_wg.dart';

import '../../../../../../core/utils/app_utils.dart';

class VacancyCardWg extends StatelessWidget {
  final VacancyEntity item;

  const VacancyCardWg({super.key, required this.item});

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
          //! Sana
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
              Expanded(
                child: Text(
                  formatVacancyPeriod(item),
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: AppTextStyles.source.medium(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          //! Lavozim
          Text(
            item.title,
            maxLines: 2,
            overflow: .ellipsis,
            style: AppTextStyles.source.medium(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: .ellipsis,
            style: AppTextStyles.source.regular(fontSize: 12),
          ),
          const SizedBox(height: 8),

          //! Shartlar
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.money_dollar_circle_line,
            title: localization.salaryLabel,
            trailing: formatVacancySalary(localization, item),
          ),
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.map_pin_line,
            title: localization.workplaceLabel,
            trailing: item.department?.name ?? '—',
          ),
          VacancyRowItemWg(
            leadingIcon: FlutterRemix.group_line,
            title: localization.vacantPlacesLabel,
            trailing: item.quantity.toString(),
          ),
          const SizedBox(height: 8),

          //! Teglar
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _tag(employmentTypeLabel(localization, item.employmentType)),
              if (item.experience != null && item.experience!.isNotEmpty)
                _tag('${localization.experienceLabel} ${item.experience}'),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => openMiniAppSheetFamily(
                    context,
                    child: VacancyDetailedWg(item: item),
                    showHandler: false,
                  ),
                  child: Text(localization.moreDetails),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String title) {
    return Text(
      '• $title',
      style: AppTextStyles.source.regular(
        fontSize: 12,
        color: AppColors.greyScale.grey600,
      ),
    );
  }
}
