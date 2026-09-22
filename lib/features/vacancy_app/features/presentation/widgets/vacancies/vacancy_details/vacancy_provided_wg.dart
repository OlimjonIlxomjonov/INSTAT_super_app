import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

import '../../../../../../../core/utils/app_utils.dart';

class VacancyProvidedWg extends StatelessWidget {
  final VacancyEntity item;

  const VacancyProvidedWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      children: [
        _containerWg(
          FlutterRemix.money_dollar_circle_line,
          '${l.salaryLabel}:',
          formatVacancySalary(l, item),
        ),
        _containerWg(
          FlutterRemix.map_pin_line,
          '${l.workplaceLabel}:',
          item.department?.name ?? '—',
        ),
        _containerWg(
          FlutterRemix.briefcase_line,
          '${l.employmentTypeLabel}:',
          employmentTypeLabel(l, item.employmentType),
        ),
        if (item.experience != null && item.experience!.isNotEmpty)
          _containerWg(
            FlutterRemix.briefcase_line,
            '${l.experienceLabel}:',
            item.experience!,
          ),
      ],
    );
  }

  Widget _containerWg(IconData icon, String title, String trailing) {
    return Container(
      margin: const .only(bottom: 8),
      padding: const .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: AppColors.greyScale.grey50,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.source.medium(fontSize: 14)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              trailing,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.medium(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
