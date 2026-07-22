import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/general_widgets/bought_book_opener/bought_book_opener_wg.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_rating_star/custom_rating_star_wg.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/extend_comment/extend_comment_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_comments/book_comments_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/leave_comment_section.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/screens_lib/user_online_book_cart_lib_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_actions/book_actions_bloc.dart'
    as my_template_book;
import '../../../../../../../core/common/flush_bar/flush_bars.dart';
import '../../../../../../../core/utils/widgets/comment_section/user_comments_wg.dart';
import '../../../../../../../core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import '../../../../../../education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';

class DetailedOnlineBookComponent extends StatefulWidget {
  final bool isBookBought, isOffline;
  final BookEntity data;

  const DetailedOnlineBookComponent({
    super.key,
    this.isBookBought = false,
    this.isOffline = false,
    required this.data,
  });

  @override
  State<DetailedOnlineBookComponent> createState() =>
      _DetailedOnlineBookComponentState();
}

class _DetailedOnlineBookComponentState
    extends State<DetailedOnlineBookComponent> {
  bool isTextFullShown = false;

  @override
  void initState() {
    super.initState();
    context.read<BookCommentsBloc>().add(
      BookCommentsEvent(
        params: OnlineBookCommentsParams(bookId: widget.data.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final average = widget.data.commentCount == 0
        ? 0.0
        : widget.data.starsSum / widget.data.commentCount;

    return Scaffold(
      /// HEADER
      appBar: CustomAppBarWg(
        myTitle: localization.aboutBook,
        customActions: [
          BlocBuilder<
            my_template_book.BookActionsBloc,
            my_template_book.BookActionsState
          >(
            builder: (context, state) {
              final bool isSaved = state.isBookSaved(
                widget.data.id,
                defaultValue: widget.data.isSaved,
              );
              return IconButton(
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(20),
                    side: BorderSide(color: AppColors.greyScale.grey200),
                  ),
                ),
                onPressed: () {
                  context.read<my_template_book.BookActionsBloc>().add(
                    my_template_book.ToggleSaveBookEvent(
                      bookId: widget.data.id,
                      isSaved: !isSaved,
                    ),
                  );
                },
                icon: Icon(
                  isSaved ? FlutterRemix.heart_fill : FlutterRemix.heart_line,
                  color: isSaved ? AppColors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //! thumbnail
          SliverToBoxAdapter(
            child: DetailedOnlineBookHeaderWg(data: widget.data),
          ),

          /// BOOK INFO & RATING
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.aboutBook,
                              style: AppTextStyles.source.medium(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            HtmlContentWg(
                              collapsedLines: 7,
                              htmlData: widget.data.description.isNotEmpty
                                  ? widget.data.description
                                  : localization.descriptionNotFound,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// rating
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        average.toStringAsFixed(1),
                        style: AppTextStyles.source.medium(fontSize: 30),
                      ),
                      VerticalDividerWg(),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomRatingStarWg(starRating: average, starSize: 25),
                          Text(
                            '${widget.data.commentCount} ta izoh',
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),

                      //! LEAVE/ADD A COMMENT
                      ElevatedButton(
                        onPressed: () {
                          onlineLibStyleCustomBottomSheetWg(
                            context,
                            headerTitle: localization.leaveComment,
                            child: LeaveCommentSection(data: widget.data),
                          );
                        },
                        child: Text(
                          localization.leaveComment,
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// COMMENTS
          SliverToBoxAdapter(
            child: BlocBuilder<BookCommentsBloc, BookCommentsState>(
              builder: (context, state) {
                if (state is BookCommentsLoaded) {
                  final data = state.response.reviews;

                  //! Empty state
                  if (data.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 35,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.greyScale.grey50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              IconlyBold.chat,
                              color: AppColors.greyScale.grey400,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Hozircha izohlar yo'q",
                            style: AppTextStyles.source.semiBold(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ushbu kitob haqida birinchi bo'lib fikr bildiring",
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                          top: 24,
                        ),
                        child: ExtendSectionSeeAllWg(
                          title: 'Izohlar',
                          onTap: () {
                            subBottomSheetOpener(
                              context,
                              child: SeeAllCourseComments(response: data),
                              isExpanded: true,
                            );
                          },
                        ),
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 220,
                          viewportFraction: 0.85,
                          enableInfiniteScroll: data.length > 1,
                          autoPlay: data.length > 1,
                        ),
                        items: data
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: GestureDetector(
                                  child: UserCommentsWg(entity: item),
                                  onTap: () {
                                    extendCommentWg(context, item);
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          /// BOOKS
          if (!widget.isBookBought)
            SliverPadding(
              padding: const .only(left: 20, right: 20, top: 40),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ExtendSectionSeeAllWg(
                      title: localization.similarBooks,
                      onTap: () {
                        // FamilyNavigation.familyPush(
                        //   context,
                        //   SimilarOnlineBooksComponent(),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          if (!widget.isBookBought)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 330,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => SizedBox(
                    width: 200,
                    child: Padding(
                      padding: .only(left: 10, right: 10),
                      child: BookGridItem(
                        type: BookCardType.market,
                        title: "Jajji shahzoda",
                        author: "Antuan de Sent-Ekzyuperi",
                        rating: 4.5,
                        price: "300 000 UZS",
                        oldPrice: "330 000 UZS",
                        imagePath: 'assets/images/temp_book.jpg',
                        onTap: () {
                          // FamilyNavigation.familyPush(
                          //   context,
                          //   DetailedOnlineBookComponent(),
                          // );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

          SliverPadding(padding: .only(bottom: 20)),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, localization),
    );
  }

  /// Only online, non-offline-cached books get a bottom action bar.
  Widget _buildBottomNavigationBar(
    BuildContext context,
    AppLocalizations localization,
  ) {
    final isOnlineBook = widget.data.type == 'online';
    if (!isOnlineBook || widget.isOffline) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<
      my_template_book.BookActionsBloc,
      my_template_book.BookActionsState
    >(
      builder: (context, state) {
        final bool inCart = state.isBookInCart(
          widget.data.id,
          defaultValue: widget.data.isInCart,
        );

        return CustomBottomNavContainerWg(
          anotherButton: inCart
              ? _buildRemoveFromCartButton(context)
              : const SizedBox.shrink(),
          buttonText: _bottomBarButtonText(localization, inCart),
          onTap: () => _onBottomBarTap(context, localization, inCart),
        );
      },
    );
  }

  String _bottomBarButtonText(AppLocalizations localization, bool inCart) {
    if (widget.isBookBought) return localization.continueReadingButton;
    if (inCart) return localization.goToCart;
    return localization.buyForPrice(widget.data.price);
  }

  Widget _buildRemoveFromCartButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.redFailedTaskCard),
        ),
      ),
      onLongPress: () {
        AppRoute.go(BoughtBookOpenerWg());
        technicalWorkFlushBar(context, 'Devloper Mode!');
      },
      onPressed: () {
        context.read<my_template_book.BookActionsBloc>().add(
          my_template_book.ToggleCartBookEvent(
            bookId: widget.data.id,
            isInCart: false,
          ),
        );
      },
      child: Icon(IconlyLight.delete, color: AppColors.red, size: 24),
    );
  }

  void _onBottomBarTap(
    BuildContext context,
    AppLocalizations localization,
    bool inCart,
  ) {
    if (widget.isBookBought) {
      AppRoute.go(const BoughtBookOpenerWg());
      return;
    }

    if (!inCart) {
      context.read<my_template_book.BookActionsBloc>().add(
        my_template_book.ToggleCartBookEvent(
          bookId: widget.data.id,
          isInCart: true,
        ),
      );
      addedToCartFlushBar(context, localization.successfullySaved);
      return;
    }

    openMiniAppSheetFamily(
      context,
      isTransparent: false,
      showHandler: false,
      child: const UserOnlineBookCartLibPage(),
    );
  }
}
