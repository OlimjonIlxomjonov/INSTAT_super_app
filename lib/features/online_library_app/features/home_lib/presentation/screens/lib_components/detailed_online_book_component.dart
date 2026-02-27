import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/bought_book_opener/bought_book_opener_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_rating_star/custom_rating_star_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/leave_comment_section.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/similar_onilne_books_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';

class DetailedOnlineBookComponent extends StatefulWidget {
  final bool isBookBought, isOffline;

  const DetailedOnlineBookComponent({
    super.key,
    this.isBookBought = false,
    this.isOffline = false,
  });

  @override
  State<DetailedOnlineBookComponent> createState() =>
      _DetailedOnlineBookComponentState();
}

class _DetailedOnlineBookComponentState
    extends State<DetailedOnlineBookComponent> {
  bool isTextFullShown = false;

  void onButtonPressed() {
    if (widget.isBookBought) {
      /// open book
      AppRoute.go(BoughtBookOpenerWg());
    } else {
      /// show payment bottom sheet
      onlineLibStyleCustomBottomSheetWg(
        context,
        headerTitle: 'To\'lov turi',
        child: PaymentOpenBottomSheetWg(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(
            isFamily: true,
            myTitle: 'Kitob haqida',
            customActions: [
              IconButton(
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(8),
                    side: BorderSide(color: AppColors.greyScale.grey200),
                  ),
                ),
                onPressed: () {},
                icon: Icon(IconlyLight.heart),
              ),
            ],
          ),

          /// HEADER
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(child: DetailedOnlineBookHeaderWg()),
          ),

          /// BOOK INFO & RATING
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Kitob haqida',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTextFullShown = !isTextFullShown;
                      });
                    },
                    child: Text(
                      maxLines: isTextFullShown ? null : 11,
                      overflow: isTextFullShown ? .visible : .ellipsis,
                      "“Motivatsiya formulasi” — bu kitob insonning ichki va tashqi rag‘batlarini tushunishga bag‘ishlangan. Unda motivatsiya nima ekanligi, qanday shakllanishi va insonning maqsad sari harakat qilishidagi o‘rni batafsil tushuntiriladi. Kitobda ichki motivatsiya — shaxsiy qiziqish, zavq va ichki istaklar, hamda tashqi motivatsiya — mukofotlar, rag‘batlar, tashqi omillar orqali harakat qilish mexanizmlari yoritilgan.Shuningdek, kitob motivatsiya formulasi asosida maqsad qo‘yish, o‘z imkoniyatlarini baholash, resurslarni samarali ishlatish va natijaga erishish yo‘llarini amaliy misollar bilan ko‘rsatadi. Har bir bo‘lim hayotiy vaziyatlar, misollar va oddiy diagrammalar orqali tushuntirilgan, shuning uchun o‘quvchi o‘zini harakatga undash va motivatsiyasini oshirish usullarini oson tushunadi.",
                      style: AppTextStyles.source.regular(
                        fontSize: 15,
                        color: AppColors.greyScale.grey600,
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
                            child: LeaveCommentSection(),
                          );
                        },
                        child: Text('Izoh qoldirish'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ExtendSectionSeeAllWg(
                    title: 'Izohlar',
                    onTap: () {
                      // customBottomSheetWg(
                      //   context,
                      //   child: SeeAllCourseComments(),
                      // );
                      subBottomSheetOpener(
                        context,
                        child: SeeAllCourseComments(),
                        isExpanded: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// COMMENTS
          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 220,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
                padEnds: false,
                autoPlay: true,
              ),
              items: [
                1,
                2,
                3,
                4,
                5,
              ].map((i) => const UserCommentsWg()).toList(),
            ),
          ),

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
                        FamilyNavigation.familyPush(
                          context,
                          SimilarOnlineBooksComponent(),
                        );
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
                          FamilyNavigation.familyPush(
                            context,
                            DetailedOnlineBookComponent(),
                          );
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
      bottomNavigationBar: !widget.isOffline
          ? CustomBottomNavContainerWg(
              buttonText: widget.isBookBought
                  ? 'O’qishni davom ettirish'
                  : 'Sotib olish - 800 000 UZS',
              onTap: onButtonPressed,
            )
          : SizedBox.shrink(),
    );
  }
}
