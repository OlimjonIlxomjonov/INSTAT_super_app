import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/widgets/reports_card_wg.dart';

import '../../../../../core/utils/widgets/edu_categories/edu_categories_wg.dart';
import '../../../../../core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'filter_bottom_sheet_wg.dart';

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
      appBar: CustomAppBarWg(myTitle: 'Hisobotlar'),
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
          ReportsCardWg(),
        ],
      ),
    );
  }
}
