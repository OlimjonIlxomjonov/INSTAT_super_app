import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/utils/widgets/extend_section/title_with_layout_selector_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/expanded_courses_card_wg.dart';
import 'package:my_template/core/utils/widgets/popular_courses_card/minimal_courses_card_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/search_courses/search_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';

class SearchCoursesPage extends StatefulWidget {
  const SearchCoursesPage({super.key});

  @override
  State<SearchCoursesPage> createState() => _SearchCoursesPageState();
}

class _SearchCoursesPageState extends State<SearchCoursesPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  CoursesLayout _layout = CoursesLayout.grid;

  @override
  void initState() {
    super.initState();
    // Auto-focus keyboard when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
    // Fire initial blank search to load all courses
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchCoursesBloc>().add(
        SearchCoursesEvent(params: SearchCoursesParams(search: query)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Search Bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appW(16),
                vertical: appH(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appW(14),
                    vertical: appH(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyScale.grey200,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyLight.search,
                        color: AppColors.greyScale.grey600,
                      ),
                      SizedBox(width: appW(8)),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: _search,
                          style: AppTextStyles.source.regular(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: localization.searchCoursesHint,
                            hintStyle: AppTextStyles.source.regular(
                              fontSize: 14,
                              color: AppColors.greyScale.grey500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: appH(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: appW(4)),
                      GestureDetector(
                        onTap: () => FamilyNavigation.familyClose(context),
                        child: Text(
                          localization.cancelShort,
                          style: AppTextStyles.source.medium(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Results ──────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<SearchCoursesBloc, SearchCoursesState>(
                builder: (context, state) {
                  if (state is SearchCoursesLoading) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: appW(16)),
                      itemCount: 4,
                      itemBuilder: (context, _) =>
                          const SkeletonExpandedCourseCard(),
                    );
                  }

                  if (state is SearchCoursesLoaded) {
                    final courses = state.response.data;
                    if (courses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              IconlyLight.search,
                              size: 56,
                              color: AppColors.greyScale.grey400,
                            ),
                            SizedBox(height: appH(16)),
                            Text(
                              localization.nothingFound,
                              style: AppTextStyles.source.medium(
                                fontSize: 16,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Layout toggle header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: appW(16)),
                          child: TitleWithLayoutSelectorWg(
                            prefsKey: 'search_courses',
                            onChanged: (v) => setState(() => _layout = v),
                          ),
                        ),
                        Expanded(
                          child: LoadMoreOnScroll(
                            canLoadMore: state.hasMore && !state.isLoadingMore,
                            onLoadMore: () => context
                                .read<SearchCoursesBloc>()
                                .add(const LoadMoreSearchCoursesEvent()),
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: appW(16),
                              ),
                              // One extra slot for the trailing spinner.
                              itemCount:
                                  courses.length +
                                  (state.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= courses.length) {
                                  return const Padding(
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
                                  );
                                }
                                final item = courses[index];
                                return CourseCategoryBuilder(
                                  categoryId: item.category,
                                  loadingBuilder: (_) =>
                                      const SkeletonExpandedCourseCard(),
                                  builder: (context, categoryName) {
                                    void openDetail() {
                                      openMiniAppSheetFamily(
                                        showHandler: false,
                                        context,
                                        child: DetailedCourseInfoPage(
                                          data: item,
                                          courseCategory: categoryName,
                                          total: state.response.meta.total,
                                        ),
                                      );
                                    }

                                    return _layout == CoursesLayout.grid
                                        ? ExpandedCoursesCardWg(
                                            entity: item,
                                            categoryName: categoryName,
                                            onTap: openDetail,
                                          )
                                        : MinimalCoursesCardWg(
                                            data: item,
                                            categoryName: categoryName,
                                            onTap: openDetail,
                                          );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is SearchCoursesError) {
                    return Center(
                      child: Text(
                        state.isConnectionError
                            ? localization.noInternetConnection
                            : localization.genericError,
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.greyScale.grey700,
                        ),
                      ),
                    );
                  }

                  // SearchCoursesInitial
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
