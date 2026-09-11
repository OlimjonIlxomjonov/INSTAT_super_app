import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import '../../../../../../core/utils/app_utils.dart';
import '../../../../../../core/utils/widgets/search_bar/app_serachbar_wg.dart';
import '../../../../../mikro_data/presentation/screens/reports/filter_bottom_sheet_wg.dart';
import '../../widgets/vacancies/vacancy_card_wg.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: localization.vacanciesTitle),
            ),
          ),
          //! Search bar
          SliverAppBar(
            toolbarHeight: 80,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () => {}),
          ),
          //! Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.vacanciesTitle,
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => showReportsFilterSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconlyLight.filter,
                            size: 14,
                            color: AppColors.greyScale.grey600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            localization.filter,
                            style: AppTextStyles.source.medium(
                              fontSize: 12,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //! Vacancies
          SliverToBoxAdapter(child: VacancyCardWg()),
        ],
      ),
    );
  }
}
