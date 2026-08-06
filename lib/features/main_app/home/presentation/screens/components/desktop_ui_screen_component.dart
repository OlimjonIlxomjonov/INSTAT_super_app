import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/test_mode_banner/test_mode_banner.dart';
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
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/user_articles_page.dart';

/// Desktop/laptop layout: same two-column idea as tablet (mini-app grid +
/// search on the left, real content on the right), but the whole thing is
/// constrained to a max width and centered — a full-bleed split row starts
/// looking absurd once the window is 1600-1900px wide, especially the
/// mini-app grid stretching out with huge gaps between cards.
class DesktopUiScreenComponent extends StatefulWidget {
  final List<MiniAppModel> sections;

  const DesktopUiScreenComponent({super.key, required this.sections});

  @override
  State<DesktopUiScreenComponent> createState() =>
      _DesktopUiScreenComponentState();
}

class _DesktopUiScreenComponentState extends State<DesktopUiScreenComponent> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _wasDisconnected = false;

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

  Widget _buildMiniAppGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        // Higher aspect ratio = shorter cards for the same width. Phone
        // keeps its own separate value in MobileUiScreenComponent.
        childAspectRatio: 1.8,
      ),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final item = widget.sections[index];
        return MiniAppSectionCard(
          mainImage: item.mainImage,
          backgroundImage: item.backgroundImage,
          title: item.title,
          onTap: item.onTap,
          colors: item.colors,
        );
      },
    );
  }

  /// Same content as MobileUiScreenComponent's sliver list, minus the mini
  /// app grid/search bar/banner (those live in the left column here).
  List<Widget> _buildContentSlivers(
    BuildContext context,
    AppLocalizations localization,
  ) {
    return [
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
            onTap: () => _goToAllCourses(context),
          ),
        ),
      ),

      //! EDU POPULAR COURSES
      SliverToBoxAdapter(child: PopularWithBlocWg()),

      //! Active Books
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: ActiveBooksWithBloc(
            onTap: () => openMiniAppSheetFamily(
              context,
              showHandler: false,
              child: const OnlineLibBottomNavBar(openPageByIndex: 1),
            ),
          ),
        ),
      ),

      /// LIBRARY POPULAR BOOKS
      BlocBuilder<PopularBooksBloc, PopularBooksState>(
        builder: (context, state) {
          const cardWidth = 220.0;

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
          final listHeight = cardWidth / 0.78 + 10 + 8 + textBlockHeight + 4;

          if (state is PopularBooksLoaded && state.response.data.isNotEmpty) {
            final books = state.response.data;
            return SliverToBoxAdapter(
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
                      padding: const EdgeInsets.only(left: 10),
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
                            padding: const EdgeInsets.only(left: 12),
                            child: BookGridItem(
                              id: book.id,
                              isSaved: book.isSaved,
                              type: BookCardType.market,
                              title: book.name,
                              rating: average,
                              author: book.author.name,
                              price: "\u{00A0}${formatPrice(book.price)} UZS",
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
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),

      SliverPadding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
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

      const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
    ];
  }

  Widget _buildContentColumn(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomRefreshIndicator(
      onRefresh: () async => _reloadAll(),
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 12)),
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

                      // Any other error (bad TLS/certificate handshake
                      // reaching the server, unexpected 5xx, malformed
                      // response, etc.) is NOT "no internet" — show a real
                      // server-error state instead of silently falling
                      // through to empty-looking sections.
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.greyScale.grey50,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const TestModeBanner(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  child: ColoredBox(
                    color: AppColors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LEFT — mini apps, search, banner (static, own
                        /// scroll)
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(top: 16, bottom: 24),
                            child: Column(
                              children: [
                                Padding(
                                  padding: AppPadding.hAndV20x20(),
                                  child: const AppSearchbarWg(),
                                ),
                                _buildMiniAppGrid(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    20,
                                    20,
                                    0,
                                  ),
                                  child: const PromoBannersCarouselWg(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// RIGHT — real content: active/popular courses,
                        /// books, articles. Its own CustomScrollView so the
                        /// existing sliver-based bloc widgets
                        /// (ActiveCoursesWithBlocWg, UserArticlesWithBlocWg)
                        /// can be reused as-is.
                        Expanded(flex: 3, child: _buildContentColumn(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
