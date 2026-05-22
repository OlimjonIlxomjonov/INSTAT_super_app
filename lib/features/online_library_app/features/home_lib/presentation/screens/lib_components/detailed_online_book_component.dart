import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/common/flush_bar/added_to_cart_flush_bar.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/general_widgets/bought_book_opener/bought_book_opener_wg.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_rating_star/custom_rating_star_wg.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/leave_comment_section.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/similar_onilne_books_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/screens_lib/user_online_book_cart_lib_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_actions/book_actions_bloc.dart'
    as my_template_book;

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
  Widget build(BuildContext context) {
    return Scaffold(
      /// HEADER
      appBar: CustomAppBarWg(
        myTitle: 'Kitob haqida',
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
                  isSaved ? Icons.favorite_rounded : IconlyLight.heart,
                  color: isSaved ? AppColors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
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
                              'Kitob haqida',
                              style: AppTextStyles.source.medium(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            HtmlContentWg(
                              collapsedLines: 7,
                              htmlData: widget.data.description.isNotEmpty
                                  ? widget.data.description
                                  : 'Izoh topilmadi',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// rating
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '4.8',
                        style: AppTextStyles.source.medium(fontSize: 30),
                      ),
                      VerticalDividerWg(),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomRatingStarWg(starRating: 4, starSize: 25),
                          Text(
                            '56 ta izoh',
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),

                      /// LEAVE A COMMENT
                      ElevatedButton(
                        onPressed: () {
                          onlineLibStyleCustomBottomSheetWg(
                            context,
                            headerTitle: 'Izoh qoldirish',
                            child: LeaveCommentSection(data: widget.data),
                          );
                        },
                        child: Text('Izoh qoldirish'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ExtendSectionSeeAllWg(
                  //   title: 'Izohlar',
                  //   onTap: () {
                  //     // subBottomSheetOpener(
                  //     //   context,
                  //     //   child: SeeAllCourseComments(),
                  //     //   isExpanded: true,
                  //     // );
                  //   },
                  // ),
                ],
              ),
            ),
          ),

          /// COMMENTS
          // SliverToBoxAdapter(
          //   child: CarouselSlider(
          //     options: CarouselOptions(
          //       height: 220,
          //       viewportFraction: 0.85,
          //       enableInfiniteScroll: true,
          //       autoPlay: true,
          //     ),
          //     items: [1]
          //         .map(
          //           (i) => Center(
          //             child: Lottie.asset(
          //               width: 100,
          //               AppAnimations.workFuv,
          //               repeat: false,
          //             ),
          //           ),
          //         )
          //         .toList(), // UserCommentsWg()
          //   ),
          // ),

          /// BOOKS
          if (!widget.isBookBought)
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ExtendSectionSeeAllWg(
                      title: 'O’xshash kitoblar',
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
      bottomNavigationBar: widget.data.type == 'online'
          ? !widget.isOffline
                ? BlocBuilder<
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
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: .circular(10),
                                    side: BorderSide(
                                      color: AppColors.redFailedTaskCard,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<my_template_book.BookActionsBloc>()
                                      .add(
                                        my_template_book.ToggleCartBookEvent(
                                          bookId: widget.data.id,
                                          isInCart: false,
                                        ),
                                      );
                                },
                                child: Icon(
                                  IconlyLight.delete,
                                  color: AppColors.red,
                                  size: 24,
                                ),
                              )
                            : const SizedBox.shrink(),
                        // onCartTap: () {},
                        buttonText: widget.isBookBought
                            ? 'O’qishni davom ettirish'
                            : inCart
                            ? 'Savatga o\'tish'
                            : 'Sotib olish - ${widget.data.price} UZS',
                        onTap: () {
                          if (widget.isBookBought) {
                            AppRoute.go(const BoughtBookOpenerWg());
                          } else if (!inCart) {
                            context
                                .read<my_template_book.BookActionsBloc>()
                                .add(
                                  my_template_book.ToggleCartBookEvent(
                                    bookId: widget.data.id,
                                    isInCart: true,
                                  ),
                                );
                            addedToCartFlushBar(
                              context,
                              'Muvaffaqiyatli saqlandi',
                            );
                          } else {
                            openMiniAppSheetFamily(
                              context,
                              isTransparent: false,
                              showHandler: false,
                              child: const UserOnlineBookCartLibPage(),
                            );
                          }
                        },
                      );
                    },
                  )
                : const SizedBox.shrink()
          : SizedBox.shrink(),
    );
  }
}
