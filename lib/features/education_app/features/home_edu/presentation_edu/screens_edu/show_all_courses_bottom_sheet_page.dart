import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class ShowAllCoursesBottomSheetPage extends StatefulWidget {
  const ShowAllCoursesBottomSheetPage({super.key});

  @override
  State<ShowAllCoursesBottomSheetPage> createState() =>
      _ShowAllCoursesBottomSheetPageState();
}

class _ShowAllCoursesBottomSheetPageState
    extends State<ShowAllCoursesBottomSheetPage> {
  CoursesLayout layout = CoursesLayout.grid;

  void _goToPage({
    required CourseEntity data,
    required String category,
    required int total,
  }) {
    FamilyNavigation.familyPush(
      context,
      showHandle: false,
      DetailedCourseInfoPage(
        data: data,
        courseCategory: category,
        total: total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      /// HEADER OF THE COURSES
      appBar: AppBar(
        toolbarHeight: 80,
        title: AppSearchbarWg(),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          final loaded = state is CoursesLoaded ? state : null;

          return LoadMoreOnScroll(
            canLoadMore:
                (loaded?.hasMore ?? false) && !(loaded?.isLoadingMore ?? false),
            onLoadMore: () =>
                context.read<CoursesBloc>().add(LoadMoreCoursesEvent()),
            child: CustomScrollView(
              slivers: [
                /// CATEGORIES
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 20),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return EduCategoriesWg();
                      }),
                    ),
                  ),
                ),

                /// COURSES
                SliverSafeArea(
                  sliver: SliverPadding(
                    padding: .symmetric(horizontal: appW(20)),
                    sliver: loaded == null
                        ? const SliverToBoxAdapter(child: SizedBox.shrink())
                        : SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: TitleWithLayoutSelectorWg(
                                  onChanged: (v) => setState(() => layout = v),
                                  prefsKey: 'all_courses',
                                ),
                              ),

                              // A real SliverList rather than a Column, so
                              // cards are built lazily as they scroll into
                              // view. That matters much more now that the
                              // list keeps growing page by page — a Column
                              // would build every loaded card (and its
                              // CourseCategoryBuilder) up front.
                              SliverList.builder(
                                itemCount: loaded.response.data.length,
                                itemBuilder: (context, index) {
                                  final item = loaded.response.data[index];
                                  // The real total from the API, not the
                                  // number loaded so far — otherwise this
                                  // would climb as pages are appended.
                                  final total = loaded.response.meta.total;

                                  return CourseCategoryBuilder(
                                    categoryId: item.category,
                                    builder: (context, categoryName) {
                                      return layout == CoursesLayout.grid
                                          ? ExpandedCoursesCardWg(
                                              onTap: () => _goToPage(
                                                data: item,
                                                category: categoryName,
                                                total: total,
                                              ),
                                              entity: item,
                                              categoryName: categoryName,
                                            )
                                          : MinimalCoursesCardWg(
                                              onTap: () => _goToPage(
                                                data: item,
                                                category: categoryName,
                                                total: total,
                                              ),
                                              data: item,
                                              categoryName: categoryName,
                                            );
                                    },
                                  );
                                },
                              ),

                              if (loaded.isLoadingMore)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
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
        },
      ),
    );
  }
}
