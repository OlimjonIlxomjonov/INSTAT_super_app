import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_application_status_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../../../../../../core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import '../applications/vacancy_application_detail_wg.dart';

class RequestsCardWg extends StatelessWidget {
  final VacancyApplicationEntity item;

  const RequestsCardWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Container(
      margin: const .symmetric(horizontal: 20),
      padding: const .all(12),
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          //! Sana va status
          Row(
            children: [
              Icon(
                FlutterRemix.calendar_line,
                size: 18,
                color: AppColors.greyScale.grey600,
              ),
              const SizedBox(width: 4),
              Text(
                formatVacancyDate(item.createdAt),
                style: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey600,
                ),
              ),
              const Spacer(),
              VacancyApplicationStatusWg(status: item.status),
            ],
          ),
          const SizedBox(height: 8),

          //! Vakansiya
          Text(
            item.vacancy?.title ?? '—',
            style: AppTextStyles.source.medium(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            item.vacancy?.subtitle ?? '',
            style: AppTextStyles.source.regular(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.requestBackgroundColorBtn,
                    foregroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () => openMiniAppSheetFamily(
                    context,
                    child: VacancyApplicationDetailWg(item: item),
                    showHandler: false,
                  ),
                  child: Text(localization.viewApplication),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
