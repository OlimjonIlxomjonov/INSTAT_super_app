import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/strings/app_strings.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';
import 'package:my_template/features/onboarding/widgets/onboarding_wg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool isLastPage = false;
  final PageController pageController = PageController();

  void moveNextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      AppRoute.open(LogInOptionsPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.systemNavigationBar(AppColors.white);

    return Scaffold(
      extendBody: true,
      body: Container(
        padding: EdgeInsets.only(bottom: appH(80)),
        child: PageView(
          onPageChanged: (int index) {
            setState(() {
              setState(() => isLastPage = index == 3);
            });
          },
          controller: pageController,
          children: [
            OnboardingWg(
              title: AppStrings.allFeaturesInOneApp,
              subTitle: AppStrings.coursesMikroTalim,
              imagePath: AppImages.firstOnboarding,
              imageWidthDivider: 1.5,
            ),
            OnboardingWg(
              title: AppStrings.singleAccountAllFeatures,
              subTitle: AppStrings.organishningBarchaFormatlari,
              imagePath: AppImages.secondOnboarding,
              imageWidthDivider: 1.2,
            ),
            OnboardingWg(
              title: AppStrings.allInYourSurround,
              subTitle: AppStrings.sizQandayOrganishniXoxlaysiz,
              imagePath: AppImages.thirdOnboarding,
              imageWidthDivider: 1,
            ),
            OnboardingWg(
              title: AppStrings.learnInDifferentFormats,
              subTitle: AppStrings.bilimniTurliYollar,
              imagePath: AppImages.fourthOnboarding,
              imageWidthDivider: 1.1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: appW(20)),
          color: AppColors.white,
          height: appH(100),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SmoothPageIndicator(
                controller: pageController,
                count: 4,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primaryColor,
                  expansionFactor: 2,
                  radius: 5,
                  dotHeight: appH(4),
                  dotWidth: appW(10),
                ),
              ),
              SizedBox(height: appH(25)),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyScale.grey50,
                      foregroundColor: AppColors.greyScale.grey600,
                    ),
                    onPressed: () {
                      pageController.jumpToPage(3);
                    },
                    child: Text("O’tkazib yuborish"),
                  ),
                  ElevatedButton(
                    onPressed: moveNextPage,
                    child: Text(isLastPage ? "Boshlash" : "Keyingisi"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
