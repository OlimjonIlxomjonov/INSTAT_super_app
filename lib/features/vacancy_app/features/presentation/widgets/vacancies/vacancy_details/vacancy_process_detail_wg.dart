import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_commission_member_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_field_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_process_item.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

class VacancyProcessDetailWg extends StatelessWidget {
  final VacancyProcessItem item;
  final String commissionTitle;

  const VacancyProcessDetailWg({
    super.key,
    required this.item,
    this.commissionTitle = 'Komissiya',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverToBoxAdapter(
            child: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: item.title, isFamily: true),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.detailTitle != null) ...[
                    VacancySectionTitleWg(title: item.detailTitle!),
                    const SizedBox(height: 12),
                  ],

                  if (item.detailDescription != null) ...[
                    Text(
                      item.detailDescription!,
                      style: AppTextStyles.source.regular(
                        fontSize: 14,
                        color: AppColors.greyScale.grey700,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  //! Maydonlar
                  for (final field in item.fields) ...[
                    VacancyInfoFieldWg(
                      label: field.label,
                      value: field.value,
                      emphasizeValue: true,
                    ),
                    const SizedBox(height: 16),
                  ],

                  //! Komissiya
                  if (item.commission.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    VacancySectionTitleWg(title: commissionTitle),
                    const SizedBox(height: 12),
                    for (final member in item.commission) ...[
                      VacancyCommissionMemberWg(
                        name: member.name,
                        phone: member.phone,
                        avatarUrl: member.avatarUrl,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
