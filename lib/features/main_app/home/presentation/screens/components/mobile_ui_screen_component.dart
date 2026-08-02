import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/lost_internet_connection_state.dart';
import 'package:my_template/core/common/ui_states/server_error_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/active_books/active_books_with_bloc.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/user_articles_with_bloc/user_articles_with_bloc_wg.dart';
import 'package:my_template/features/education_app/features/edu_bottom_nav_bar.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/show_all_courses_bottom_sheet_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/widgets/active_courses_with_bloc_wg.dart';
import 'package:my_template/core/utils/widgets/promo_banners/promo_banners_carousel_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/courses/courses_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/mini_app_section_card.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/model/mini_app_model.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/popular_course_with_bloc/popular_with_bloc_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/similar_onilne_books_component.dart';
import 'package:my_template/features/online_library_app/features/online_lib_bottom_nav_bar.dart';

import '../../../../../../core/common/test_mode_banner/test_mode_banner.dart';
import '../../../../../scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import '../../../../../scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import '../../../../../scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

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
    context.read<BannerBloc>().add(const FetchBannersEvent());
    context.read<UserCoursesBloc>().add(
      UserCoursesEvent(params: UserCoursesParams(state: 'in_progress')),
    );
    context.read<UserMeBloc>().add(UserMeEvent());
    context.read<PopularBooksBloc>().add(FetchPopularBooksEvent());
    context.read<UserArticlesBloc>().add(
      UserArticlesEvent(status: 'all', search: ''),
    );
    context.read<UserBookBloc>().add(UserBooksEvent());
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  double _measureLineHeight(BuildContext context, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: 'Ag', style: style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.height;
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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
      SliverToBoxAdapter(child: PromoBannersCarouselWg()),

      //! ACTIVE COURSES
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

      //! EDU POPULAR COURSES
      SliverToBoxAdapter(child: PopularWithBlocWg()),

      //! Active Books
      SliverPadding(
        padding: const .symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: ActiveBooksWithBloc(
            onTap: () => openMiniAppSheetFamily(
              context,
              showHandler: false,
              child: OnlineLibBottomNavBar(openPageByIndex: 1),
            ),
          ),
        ),
      ),

      /// LIBRARY POPULAR BOOKS
      BlocBuilder<PopularBooksBloc, PopularBooksState>(
        builder: (context, state) {
          final cardWidth = MediaQuery.sizeOf(context).width * 0.46;

          final titleLineHeight = _measureLineHeight(
            context,
            AppTextStyles.source.medium(fontSize: 15),
          );
          final authorLineHeight = _measureLineHeight(
            context,
            AppTextStyles.source.regular(fontSize: 13),
          );
          final priceLineHeight = _measureLineHeight(
            context,
            AppTextStyles.source.regular(fontSize: 14),
          );

          final textBlockHeight =
              authorLineHeight + 4 + titleLineHeight + priceLineHeight;
          final listHeight =
              cardWidth / 0.78 +
              10 +
              8 +
              textBlockHeight +
              4; // small rounding buffer

          //! empty state

          if (state is PopularBooksLoaded && state.response.data.isNotEmpty) {
            final books = state.response.data;

            return SliverSafeArea(
              top: false,
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: AppPadding.horizontal20x(),
                      child: ExtendSectionSeeAllWg(
                        title: localization.mostPopularBooks,
                        onTap: () {
                          openMiniAppSheetFamily(
                            context,
                            showHandler: false,
                            child: SimilarOnlineBooksComponent(data: books),
                          );
                        },
                      ),
                    ),

                    /// books
                    SizedBox(
                      height: listHeight,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        padding: EdgeInsets.only(left: 10),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          final average = book.commentCount == 0
                              ? 0.0
                              : book.starsSum / book.commentCount;

                          final thumbnail = book.bookThumbnails.isNotEmpty
                              ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${book.bookThumbnails.first.file}'
                              : '';
                          return SizedBox(
                            width: cardWidth,
                            child: Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: BookGridItem(
                                id: book.id,
                                isSaved: book.isSaved,
                                type: BookCardType.market,
                                title: book.name,
                                rating: average,
                                author: book.author.name,
                                price: "\u{00A0}${book.price} UZS",
                                imagePath: thumbnail.isNotEmpty
                                    ? thumbnail
                                    : 'assets/images/temp_book.jpg',
                                onTap: () {
                                  openMiniAppSheetFamily(
                                    context,
                                    showHandler: false,
                                    child: DetailedOnlineBookComponent(
                                      data: book,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PopularBooksError) {
            if (state.isConnectionError) {
              return const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ); // Handled at page level mostly, but prevent crash
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          // Loading or initial state
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),

      SliverPadding(
        padding: const .only(left: 20, right: 20, top: 24),
        sliver: SliverToBoxAdapter(
          child: ExtendSectionSeeAllWg(
            title: localization.yourArticles,
            onTap: () {
              openMiniAppSheetFamily(
                showHandler: false,
                enableDrag: true,
                context,
                child: const UserArticlesPage(),
              );
            },
          ),
        ),
      ),

      /// ARTICLES
      UserArticlesWithBlocWg(limit: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          _reloadAll();
        },

        child: CustomScrollView(
          slivers: [
            // const SliverAppBar(
            //   title: TestModeBanner(),
            //   automaticallyImplyLeading: false,
            //   titleSpacing: 0,
            // ),

            /// HEADER LOGO
            SliverAppBar(
              snap: true,
              floating: true,
              leading: IconButton(
                onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(FlutterRemix.menu_line),
              ),
              title: SvgPicture.asset(AppVectors.homeInstatLogo),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FlutterRemix.notification_2_line),
                ),
              ],
            ),

            /// MINI APP SECTION
            _buildMiniAppGrid(context),

            /// SEARCH BAR
            SliverPadding(
              padding: const .only(bottom: 24, top: 32),
              sliver: SliverAppBar(
                pinned: false,
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
                    return BlocBuilder<UserMeBloc, UserMeState>(
                      buildWhen: (prev, curr) =>
                          curr is UserMeError ||
                          curr is UserMeLoading ||
                          curr is UserMeLoaded,
                      builder: (context, userMeState) {
                        final isConnectionError =
                            (coursesState is CoursesError &&
                                coursesState.isConnectionError) ||
                            (userCoursesState is UserCoursesError &&
                                userCoursesState.isConnectionError);

                        if (isConnectionError) {
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: LostInternetConnectionState(
                              onRetry: _reloadAll,
                            ),
                          );
                        }

                        final hasServerError =
                            (coursesState is CoursesError &&
                                !coursesState.isConnectionError) ||
                            (userCoursesState is UserCoursesError &&
                                !userCoursesState.isConnectionError) ||
                            userMeState is UserMeError;

                        if (hasServerError) {
                          final statusCode = userMeState is UserMeError
                              ? userMeState.statusCode
                              : null;
                          final message = userMeState is UserMeError
                              ? userMeState.message
                              : null;
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: ServerErrorState(
                              onRetry: _reloadAll,
                              statusCode: statusCode,
                              message: message,
                            ),
                          );
                        }

                        return SliverMainAxisGroup(
                          slivers: _buildContentSlivers(context, localization),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
