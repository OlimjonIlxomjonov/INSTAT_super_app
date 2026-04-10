import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/placeholder/banner_placeholder.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/search_courses_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/widgets_edu/home_achivements_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_bloc.dart';
import 'package:my_template/features/education_app/widgets/active_courses_with_bloc_wg.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/popular_course_with_bloc/popular_with_bloc_wg.dart';

class HomeEduPage extends StatelessWidget {
  final VoidCallback onTap, onProfileTap;

  const HomeEduPage({
    super.key,
    required this.onTap,
    required this.onProfileTap,
  });

  void _goToAllCourses(BuildContext context) {
    FamilyNavigation.familyPush(
      context,
      const ShowAllCoursesBottomSheetPage(),
      showHandle: false,
    );
  }

  void _openSearch(BuildContext context) {
    FamilyNavigation.familyPush(
      showHandle: false,
      context,
      BlocProvider(
        create: (_) => sl<SearchCoursesBloc>(),
        child: const SearchCoursesPage(),
      ),
    );
  }

  static const List<Widget> _categories = [
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: DraggableAppBarWg(onProfileTap: onProfileTap),
      body: CustomScrollView(
        slivers: [
          /// HOME HEADER
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () => _openSearch(context)),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                switch (index) {
                  case 0:
                    return BannerPlaceholder();
                  case 1:
                    return HomeAchievementsWg();
                  default:
                    return const SizedBox.shrink();
                }
              }, childCount: 2),
            ),
          ),

          /// Active User Courses
          ActiveCoursesWithBlocWg(onSeeAll: onTap),

          /// SELECT CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 20),
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories),
            ),
          ),

          /// All Courses
          SliverSafeArea(
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: appW(20),
                      right: appW(20),
                      top: appH(10),
                    ),
                    child: ExtendSectionSeeAllWg(
                      title: localization.allCourses,
                      onTap: () => _goToAllCourses(context),
                    ),
                  );
                }
                return PopularWithBlocWg();
              }, childCount: 2),
            ),
          ),
        ],
      ),
    );
  }
}
