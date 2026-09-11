import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../../../../../../core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import '../../../../../scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';
import '../applications/vacancy_application_detail_wg.dart';

class RequestsCardWg extends StatelessWidget {
  const RequestsCardWg({super.key});

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
          //! 1
          Row(
            children: [
              Icon(
                FlutterRemix.calendar_line,
                size: 18,
                color: AppColors.greyScale.grey600,
              ),
              const SizedBox(width: 4),
              Text(
                '12.03.2026',
                style: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey600,
                ),
              ),
              const Spacer(),
              StatusContainerWg(
                icon: FlutterRemix.loader_2_line,
                statusTitle: ' ${localization.statusUnderReview}',
                iconColor: AppColors.orange500,
                backgroundColor: AppColors.orange50,
              ),
            ],
          ),
          const SizedBox(height: 8),
          //! 2
          Text(
            'Senior Frontend Developer',
            style: AppTextStyles.source.medium(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text('Operator', style: AppTextStyles.source.regular(fontSize: 12)),
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
                    child: const VacancyApplicationDetailWg(),
                    showHandler: false,
                  ),
                  child: Text(localization.viewVacancy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
