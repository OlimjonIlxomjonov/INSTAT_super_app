import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';

import '../../../../../core/utils/widgets/edu_categories/edu_categories_wg.dart';
import '../../../../../core/utils/widgets/search_bar/app_serachbar_wg.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  static const List<Widget> _categories = [
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Hisobotlar', showArrow: false),
      body: CustomScrollView(
        slivers: [
          //! SEARCH BAR
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () {}),
          ),
          //! Categories
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories),
            ),
          ),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Hisobotlar',
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                  InkWell(
                    borderRadius: .circular(6),
                    onTap: () {},
                    child: Container(
                      padding: const .symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: .circular(6),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Text(
                        'Filter',
                        style: AppTextStyles.source.medium(
                          fontSize: 12,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
