import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/similar_courses/similar_courses_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/similar_courses/similar_courses_state.dart';

import '../../../../../../../../core/common/ui_states/app_empty_state.dart';
import '../../../../../../../../core/utils/enums/app_enums.dart';
import '../../../../../../../../core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import '../../../../../../../../core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import '../../../../../../../../core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import '../../../../../user_courses_edu/domain/entity/courses/courses_entity.dart';
import '../../../../../user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';
import '../../detailed_course_info_page.dart';

class SeeAllSimilarCourses extends StatefulWidget {
  const SeeAllSimilarCourses({super.key});

  @override
  State<SeeAllSimilarCourses> createState() => _SeeAllSimilarCoursesState();
}

class _SeeAllSimilarCoursesState extends State<SeeAllSimilarCourses> {
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverDefaultAppBarWg(
          //   myTitle: AppLocalizations.of(context)!.similarCourses,
          // ),
          //! App Bar
          SliverAppBar(
            toolbarHeight: 65,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(
                myTitle: AppLocalizations.of(context)!.similarCourses,
              ),
            ),
          ),

          //! Search
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: 75,
            title: AppSearchbarWg(),
            automaticallyImplyLeading: false,
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<SimilarCoursesBloc, SimilarCoursesState>(
                builder: (context, state) {
                  if (state is SimilarCoursesLoaded) {
                    final data = state.listEntity;

                    //! Empty State
                    if (data.isEmpty) {
                      return AppEmptyState(
                        title: "O‘xshash kurslar topilmadi.",
                        subtitle:
                            "Hozircha ushbu mavzuga mos keladigan boshqa kurslar mavjud emas.",
                      );
                    }

                    return Column(
                      children: [
                        //! Courses
                        TitleWithLayoutSelectorWg(
                          prefsKey: 'expanded',
                          onChanged: (v) => setState(() => layout = v),
                        ),
                        Column(
                          children: List.generate(data.length, (index) {
                            final item = data[index];
                            return CourseCategoryBuilder(
                              categoryId: item.category,
                              builder: (context, categoryName) {
                                return layout == CoursesLayout.grid
                                    ? ExpandedCoursesCardWg(
                                        onTap: () => _goToPage(
                                          data: item,
                                          category: categoryName,
                                          total: data.length,
                                        ),
                                        entity: data[index],
                                        categoryName: categoryName,
                                      )
                                    : MinimalCoursesCardWg(
                                        onTap: () => _goToPage(
                                          data: item,
                                          category: categoryName,
                                          total: data.length,
                                        ),
                                        data: data[index],
                                        categoryName: categoryName,
                                      );
                              },
                            );
                          }),
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
