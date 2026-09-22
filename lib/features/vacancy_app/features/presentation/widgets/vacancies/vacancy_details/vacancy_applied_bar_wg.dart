import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_application_detail_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/applications/vacancy_application_status_wg.dart';

class VacancyAppliedBarWg extends StatelessWidget {
  final VacancyApplicationEntity application;

  const VacancyAppliedBarWg({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(appW(12), appH(16), appW(12), appH(20)),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: AppColors.greyScale.grey200,
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //! Holat
            Row(
              children: [
                const Icon(
                  FlutterRemix.checkbox_circle_fill,
                  size: 20,
                  color: AppColors.iconGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.alreadyApplied,
                    style: AppTextStyles.source.medium(
                      fontSize: 13,
                      color: AppColors.greyScale.grey700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                VacancyApplicationStatusWg(status: application.status),
              ],
            ),
            const SizedBox(height: 12),

            //! Arizani ko'rish
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => openMiniAppSheetFamily(
                  context,
                  child: VacancyApplicationDetailWg(item: application),
                  showHandler: false,
                ),
                icon: const Icon(FlutterRemix.file_list_2_line, size: 20),
                label: Text(
                  l.viewApplication,
                  style: AppTextStyles.source.medium(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
