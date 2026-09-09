import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_apply_form_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_body_wg.dart';

class VacancyDetailedWg extends StatelessWidget {
  const VacancyDetailedWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(
                myTitle: "Vakansiya ma'lumotlari",
                customActions: [
                  IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(12),
                        side: BorderSide(color: AppColors.greyScale.grey200),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      FlutterRemix.heart_line,
                      size: 18,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //! Body
          SliverPadding(
            padding: const .symmetric(horizontal: 20, vertical: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  //! E’lon sanasi
                  Row(
                    children: [
                      Text(
                        'E’lon qilingan sana:',
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '12.01.2001 - 31.01.2001',
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const VacancyInfoBodyWg(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Ariza yuborish',
        onTap: () => openMiniAppSheetFamily(
          context,
          child: const VacancyApplyFormWg(),
          showHandler: false,
        ),
      ),
    );
  }
}
