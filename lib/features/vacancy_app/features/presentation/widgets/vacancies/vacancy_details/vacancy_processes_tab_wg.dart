import 'package:flutter/material.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/process_timeline/process_timeline_item_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_process_detail_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_process_item.dart';

class VacancyProcessesTabWg extends StatelessWidget {
  final List<VacancyProcessItem> items;
  final String emptyTitle;
  final String Function(int cycle) cycleLabel;

  const VacancyProcessesTabWg({
    super.key,
    required this.items,
    required this.emptyTitle,
    required this.cycleLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: AppEmptyState(title: emptyTitle),
      );
    }

    //! Sikllar
    final grouped = <int, List<VacancyProcessItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.cycle, () => []).add(item);
    }
    final cycles = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in cycles) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(cycleLabel(entry.key), style: CustomTextStyles.h2),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Column(
              children: List.generate(entry.value.length, (index) {
                final item = entry.value[index];
                return ProcessTimelineItemWg(
                  icon: Icon(
                    item.isDone
                        ? Icons.check_circle
                        : Icons.radio_button_checked,
                    color: item.isDone
                        ? AppColors.greenDoneTaskCard
                        : AppColors.primaryColor,
                  ),
                  title: item.title,
                  subtitle: item.description,
                  date: item.date,
                  isLast: index == entry.value.length - 1,
                  onTap: () => openMiniAppSheetFamily(
                    context,
                    child: VacancyProcessDetailWg(item: item),
                    showHandler: false,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}
