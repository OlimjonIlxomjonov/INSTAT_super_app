import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/wb_blocs/popular_books_with_bloc_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class SeeAllOnlineBooksComponent extends StatelessWidget {
  const SeeAllOnlineBooksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Kitoblar'),
          SliverPadding(
            padding: .symmetric(horizontal: appW(20)),
            sliver: SliverAppBar(
              toolbarHeight: 56 + 24,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: AppSearchbarWg(),
            ),
          ),

          /// CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return EduCategoriesWg();
                }),
              ),
            ),
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Kitoblar',
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
            ),
          ),

          /// BODY
          PopularBooksWithBlocWg(),
        ],
      ),
    );
  }
}
