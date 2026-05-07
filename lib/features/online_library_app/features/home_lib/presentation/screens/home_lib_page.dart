import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/placeholder/banner_placeholder.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/dragble_app_bar/draggble_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/wb_blocs/popular_books_with_bloc_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/search_books/search_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/see_all_online_books_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/search_books_page.dart';

class HomeLibPage extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onProfileTap;

  const HomeLibPage({
    super.key,
    required this.onTap,
    required this.onProfileTap,
  });

  @override
  State<HomeLibPage> createState() => _HomeLibPageState();
}

class _HomeLibPageState extends State<HomeLibPage> {
  void activeCourseOpener() {
    // openMiniAppSheetFamily(
    //   context,
    //   child: DetailedOnlineBookComponent(isBookBought: true),
    // );
  }

  void _openSearch(BuildContext context) {
    FamilyNavigation.familyPush(
      showHandle: false,
      context,
      BlocProvider(
        create: (_) => sl<SearchBooksBloc>(),
        child: const SearchBooksPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DraggableAppBarWg(onProfileTap: widget.onProfileTap),
      body: CustomScrollView(
        slivers: [
          /// search
          SliverAppBar(
            toolbarHeight: 56 + 24,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () => _openSearch(context)),
          ),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(child: BannerPlaceholder()),
          ),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: appH(15)),
                  // ExtendSectionSeeAllWg(
                  //   title: 'O’qilayotgan kitoblar',
                  //   onTap: widget.onTap,
                  // ),
                  // ActiveCoursesWg(
                  //   showCircularProgBar: false,
                  //   onTap: activeCourseOpener,
                  // ),
                  // ActiveCoursesWg(
                  //   showCircularProgBar: false,
                  //   onTap: activeCourseOpener,
                  // ),
                  SizedBox(height: appH(18)),
                ],
              ),
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
              child: ExtendSectionSeeAllWg(
                title: 'Kitoblar',
                onTap: () {
                  openMiniAppSheetFamily(
                    showHandler: false,
                    context,
                    child: SeeAllOnlineBooksComponent(),
                  );
                },
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
