import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/finish_lesson_test_dialog/finish_lesson_test_dialog_screen.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class RegularTestCoursePage extends StatefulWidget {
  const RegularTestCoursePage({super.key});

  @override
  State<RegularTestCoursePage> createState() => _RegularTestCoursePageState();
}

class _RegularTestCoursePageState extends State<RegularTestCoursePage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// TEST HEADER
          SliverPadding(
            padding: .only(top: appH(20), left: appW(20), right: appW(20)),
            sliver: SliverAppBar(
              floating: true,
              leading: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(8),
                    side: BorderSide(color: AppColors.greyScale.grey200),
                  ),
                ),
                onPressed: () {
                  AppRoute.close();
                },
                icon: Icon(IconlyLight.arrow_left_2, size: 20),
              ),
              centerTitle: true,
              title: LinearProgressIndicator(
                value: 0.3,
                minHeight: 16,
                borderRadius: .circular(35),
                color: AppColors.primaryColor,
              ),
              actions: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(8),
                      side: BorderSide(color: AppColors.greyScale.grey200),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.close();
                  },
                  icon: Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),

          /// QUESTION
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    '1-Savol',
                    style: AppTextStyles.source.medium(fontSize: 22),
                  ),
                  SizedBox(height: appH(16)),
                  Container(
                    padding: .all(24),
                    decoration: BoxDecoration(
                      borderRadius: .circular(16),
                      color: AppColors.greyScale.grey50,
                      border: .all(color: AppColors.greyScale.grey200),
                    ),
                    child: Text(
                      textAlign: .center,
                      'Iqtisodiyot tarmoqlari statistikasi asosan nimani o‘rganadi?',
                      style: AppTextStyles.source.medium(fontSize: 17),
                    ),
                  ),
                  SizedBox(height: appH(20)),
                  ...List.generate(
                    4,
                    (index) => DefaultCustomTileWg(
                      onTap: () {},
                      tileAction: Checkbox(value: false, onChanged: (temp) {}),
                      tileTitle:
                          'Tarmoqlar bo‘yicha ishlab chiqarish hajmi, o‘sish sur’atlari va samaradorlik ko‘rsatkichlarini',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Tasdiqlash',
        onTap: () {
          _confettiController.play();

          /// FINISH THE ONE LESSON TEST DIALOG
          finishLessonTestDialogScreen(
            context,
            header: Container(
              width: 230,
              height: 174,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: SvgImageProvider(AppVectors.trophyBackground),
                ),
              ),
              child: Image.asset(AppImages.trophy),
            ),
            title: 'Ajoyib natija',
            subTitle:
                "Keyingi safar ko'proq o'rganing va barcha to'g'ri javoblarni oling.",
            body: Container(
              padding: .all(12),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey50,
                border: .all(color: AppColors.greyScale.grey200),
                borderRadius: .circular(12),
              ),
              child: Row(
                mainAxisSize: .min,
                mainAxisAlignment: .spaceEvenly,
                children: [
                  buildColumn(title: '80%', subTitle: '2 ta'),
                  buildColumn(
                    title: '4 ⭐',
                    subTitle: '8 ta',
                    titleDesc: 'Berilgan ball',
                    subTitleDesc: 'To’g’ri javoblar',
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AppRoute.close();
                  },
                  child: Text('Davom etish'),
                ),
              ),
            ],
            confettiController: _confettiController,
          );

          /// FINISH FULL COURSE TEST DIALOG (TEMP LOCATION)
          // finishLessonTestDialogScreen(
          //   context,
          //   header: SvgPicture.asset(AppVectors.finishFullCourseTestDialogImg),
          //   title: 'Kurs yakunlandi',
          //   subTitle: "Kurs haqida o’zingizni izohingizni qoldiring!",
          //   body: SingleChildScrollView(
          //     child: Column(
          //       mainAxisSize: .min,
          //       children: [
          //         StarRating(
          //           starCount: 5,
          //           rating: 4,
          //           color: AppColors.orange,
          //           size: 28,
          //           borderColor: AppColors.greyScale.grey200,
          //         ),
          //         SizedBox(height: appH(15)),
          //         TextField(
          //           maxLength: 200,
          //           minLines: 3,
          //           decoration: InputDecoration(hintText: 'Mavzuni yozing...'),
          //           maxLines: null,
          //         ),
          //       ],
          //     ),
          //   ),
          //   actions: [
          //     Padding(
          //       padding: .only(bottom: appH(16)),
          //       child: SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: () {},
          //           child: Text('Davom etish'),
          //         ),
          //       ),
          //     ),
          //     SizedBox(
          //       width: double.infinity,
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: AppColors.greyScale.grey50,
          //           foregroundColor: AppColors.greyScale.grey600,
          //         ),
          //         onPressed: () {},
          //         child: Text('Davom etish'),
          //       ),
          //     ),
          //   ],
          //   confettiController: _confettiController,
          // );
        },
      ),
    );
  }

  Column buildColumn({
    required String title,
    required String subTitle,
    titleDesc = 'Noto’g’ri javob',
    subTitleDesc = 'Tugatish foizi',
  }) {
    return Column(
      mainAxisSize: .min,
      children: [
        Text(title, style: AppTextStyles.source.medium(fontSize: 20)),
        Text(
          titleDesc,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey600,
          ),
        ),
        SizedBox(height: appH(12)),
        Text(subTitle, style: AppTextStyles.source.medium(fontSize: 20)),
        Text(
          subTitleDesc,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey600,
          ),
        ),
      ],
    );
  }
}
