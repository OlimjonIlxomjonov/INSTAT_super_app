import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/courses/course_shimmer.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/detailed_course_info_page.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/detailed_user_bought_courses_edu_page.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/components/course_category_builder.dart';

class MobileUiScreenComponent extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<MiniAppModel> sections;

  const MobileUiScreenComponent({
    super.key,
    required this.sections,
    required this.scaffoldKey,
  });

  @override
  State<MobileUiScreenComponent> createState() =>
      _MobileUiScreenComponentState();
}

class _MobileUiScreenComponentState extends State<MobileUiScreenComponent> {
  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(AvailableCoursesEvent());
    context.read<UserCoursesBloc>().add(
      UserCoursesEvent(params: UserCoursesParams(state: 'all')),
    );
  }

  void _goToUserCourses(BuildContext context) {
    openMiniAppSheetFamily(
      isTransparent: false,
      showHandler: false,
      context,
      child: const EduBottomNavBar(openPageByIndex: 2),
    );
  }

  void _goToAllCourses(BuildContext context) {
    openMiniAppSheetFamily(
      context,
      child: const ShowAllCoursesBottomSheetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        /// HEADER LOGO
        SliverAppBar(
          snap: true,
          floating: true,
          leading: IconButton(
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          title: SvgPicture.asset(AppVectors.homeInstatLogo),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(IconlyLight.notification),
            ),
          ],
        ),

        /// MINI APP SECTION
        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 2
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1, // 1.3
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = widget.sections[index];
              return MiniAppSectionCard(
                mainImage: item.mainImage,
                backgroundImage: item.backgroundImage,
                title: item.title,
                onTap: item.onTap,
              );
            }, childCount: widget.sections.length),
          ),
        ),

        /// SEARCH BAR
        SliverPadding(
          padding: .only(bottom: 20),
          sliver: SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            title: const AppSearchbarWg(),
          ),
        ),

        /// BANNERS
        SliverToBoxAdapter(
          child: Container(
            margin: AppPadding.horizontal20x(),
            width: double.infinity,
            height: 200,
            color: AppColors.greyScale.grey400,
            child: Center(child: Text('PLACEHOLDER')),
          ),
        ),

        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: ExtendSectionSeeAllWg(
              title: localization.studyingCourses,
              onTap: () {
                _goToUserCourses(context);
              },
            ),
          ),
        ),

        /// ACTIVE COURSES
        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: BlocBuilder<UserCoursesBloc, UserCoursesState>(
              builder: (context, state) {
                if (state is UserCoursesLoaded) {
                  final data = state.response.data;
                  return Column(
                    children: List.generate(2, (index) {
                      final item = data[index];
                      return CourseCategoryBuilder(
                        categoryId: item.category,
                        loadingBuilder: (context) => const SizedBox.shrink(),
                        builder: (context, categoryName) {
                          return ActiveCoursesWg(
                            onTap: () {
                              openMiniAppSheetFamily(
                                showHandler: false,
                                context,
                                child: DetailedUserBoughtCoursesEduPage(
                                  data: item,
                                  categoryName: categoryName,
                                ),
                              );
                            },
                            data: item,
                            categoryName: categoryName,
                          );
                        },
                      );
                    }),
                  );
                } else if (state is UserCoursesLoading) {
                  return SkeletonMinimalCourseCard();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),

        SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: ExtendSectionSeeAllWg(
              title: localization.popularCourses,
              onTap: () {
                _goToAllCourses(context);
              },
            ),
          ),
        ),

        /// EDU POPULAR COURSES
        SliverSafeArea(
          top: false,
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: appH(280),
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  if (state is CoursesLoaded) {
                    final data = state.response.data;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: AppPadding.horizontal20x(),
                      itemCount: data.length,
                      cacheExtent: appW(300),
                      itemExtent: appW(312),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: EdgeInsets.only(right: appW(12)),
                          child: CourseCategoryBuilder(
                            categoryId: item.category,
                            loadingBuilder: (context) =>
                                const SizedBox.shrink(),
                            builder: (context, categoryName) {
                              return PopularCoursesCardWg(
                                onTap: () {
                                  openMiniAppSheetFamily(
                                    showHandler: false,
                                    context,
                                    child: DetailedCourseInfoPage(
                                      total: state.response.meta.total,
                                      data: item,
                                      courseCategory: categoryName,
                                    ),
                                  );
                                },
                                data: item,
                                categoryName: categoryName,
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is CoursesLoading) {
                    return SkeletonExpandedCourseCard();
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
