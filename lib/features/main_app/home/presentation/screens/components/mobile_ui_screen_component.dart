import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/placeholder/banner_placeholder.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/lost_internet_connection_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/widgets/active_courses_with_bloc_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/popular_course_with_bloc/popular_with_bloc_wg.dart';

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
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasDisconnected = false;
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _reloadAll();
    _checkInitialConnectivity();
    _listenToConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final hasInternet = results.any((r) => r != ConnectivityResult.none);
    if (!hasInternet) {
      _wasDisconnected = true;
    }
  }

  void _listenToConnectivity() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);

      if (hasInternet && _wasDisconnected) {
        _wasDisconnected = false;
        _reloadAll();
      } else if (!hasInternet) {
        _wasDisconnected = true;
      }
    });
  }

  void _reloadAll() {
    context.read<CoursesBloc>().add(AvailableCoursesEvent());
    context.read<UserCoursesBloc>().add(
      UserCoursesEvent(params: UserCoursesParams(state: 'all')),
    );
    context.read<UserMeBloc>().add(UserMeEvent());
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  void _goToAllCourses(BuildContext context) {
    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: const ShowAllCoursesBottomSheetPage(),
    );
  }

  Widget _buildMiniAppGrid(BuildContext context) {
    final items = widget.sections;
    final int total = items.length;
    if (total == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());

    final bool isOdd = total.isOdd;
    final int rowCount = (total / 2).ceil();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverList.builder(
        itemCount: rowCount,
        itemBuilder: (context, rowIndex) {
          final int leftIndex = rowIndex * 2;
          final int rightIndex = leftIndex + 1;

          final bool isLastRow = rowIndex == rowCount - 1;
          final bool isFullWidth = isLastRow && isOdd;

          Widget buildCard(int index) => AspectRatio(
            aspectRatio: 2.1,
            child: MiniAppSectionCard(
              mainImage: items[index].mainImage,
              backgroundImage: items[index].backgroundImage,
              title: items[index].title,
              onTap: items[index].onTap,
              colors: items[index].colors,
            ),
          );

          Widget buildFullWidthCard(int index) => AspectRatio(
            aspectRatio: 4.2,
            child: MiniAppSectionCard(
              mainImage: items[index].mainImage,
              backgroundImage: items[index].backgroundImage,
              title: items[index].title,
              onTap: items[index].onTap,
              colors: items[index].colors,
            ),
          );

          return Padding(
            padding: EdgeInsets.only(top: rowIndex == 0 ? 0 : 10),
            child: isFullWidth
                ? buildFullWidthCard(leftIndex)
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: buildCard(leftIndex)),
                        const SizedBox(width: 10),
                        Expanded(child: buildCard(rightIndex)),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  /// Builds all content slivers shown below the search bar when online.
  List<Widget> _buildContentSlivers(
    BuildContext context,
    AppLocalizations localization,
  ) {
    return [
      /// BANNERS
      SliverPadding(
        padding: AppPadding.horizontal20x(),
        sliver: SliverToBoxAdapter(child: BannerPlaceholder()),
      ),

      /// ACTIVE COURSES
      ActiveCoursesWithBlocWg(
        onSeeAll: () => openMiniAppSheetFamily(
          isTransparent: false,
          showHandler: false,
          context,
          child: const EduBottomNavBar(openPageByIndex: 2),
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
        sliver: SliverToBoxAdapter(child: PopularWithBlocWg()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomRefreshIndicator(
      onRefresh: () async {
        _reloadAll();
      },

      child: CustomScrollView(
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
          _buildMiniAppGrid(context),

          /// SEARCH BAR
          SliverPadding(
            padding: .only(bottom: 20),
            sliver: SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              title: const AppSearchbarWg(),
            ),
          ),

          BlocBuilder<CoursesBloc, CoursesState>(
            buildWhen: (prev, curr) =>
                curr is CoursesError ||
                curr is CoursesLoading ||
                curr is CoursesLoaded,
            builder: (context, coursesState) {
              return BlocBuilder<UserCoursesBloc, UserCoursesState>(
                buildWhen: (prev, curr) =>
                    curr is UserCoursesError ||
                    curr is UserCoursesLoading ||
                    curr is UserCoursesLoaded,
                builder: (context, userCoursesState) {
                  final isConnectionError =
                      (coursesState is CoursesError &&
                          coursesState.isConnectionError) ||
                      (userCoursesState is UserCoursesError &&
                          userCoursesState.isConnectionError);

                  if (isConnectionError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: LostInternetConnectionState(onRetry: _reloadAll),
                    );
                  }

                  return SliverMainAxisGroup(
                    slivers: _buildContentSlivers(context, localization),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
