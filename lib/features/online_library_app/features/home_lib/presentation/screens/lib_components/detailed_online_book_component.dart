import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/comment_section/user_comments_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/extend_section/extend_section_see_all_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/custom_bottom_sheet_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/see_all_course_comments/see_all_course_comments.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';

class DetailedOnlineBookComponent extends StatefulWidget {
  const DetailedOnlineBookComponent({super.key});

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
                          StarRating(
                            starCount: 5,
                            rating: 4,
                            color: AppColors.orange,
                            size: 25,
                            borderColor: AppColors.greyScale.grey200,
                          ),
                          Text(
                            '56 ta izoh',
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Izoh qoldirish'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ExtendSectionSeeAllWg(
                    title: 'Izohlar',
                    onTap: () {
                      // FamilyNavigation.familyPush().
                      customBottomSheetWg(
                        context,
                        child: SeeAllCourseComments(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 220,
                viewportFraction: 0.85,
                enableInfiniteScroll: false,
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
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  ExtendSectionSeeAllWg(
                    title: 'O’xshash kitoblar',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
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
                      imagePath: 'assets/images/temp_book.jpg',
                      rating: 4.5,
                      author: 'Antuan de Sent-Ekzyuperi',
                      title: 'Jajji shahzoda',
                      price: '300 000 UZS',
                      oldPrice: index.isOdd ? null : '330 000 UZS',
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
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Sotib olish - 800 000 UZS',
        onTap: () {},
      ),
    );
  }
}
