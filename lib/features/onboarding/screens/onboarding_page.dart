import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
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
    TDeviceUtils.setStatusBarColor(AppColors.transparent, darkIcons: true);
    TDeviceUtils.systemNavigationBar(AppColors.white);
    final localization = AppLocalizations.of(context)!;
    final isMobile = Responsive.isMobile(context);

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
              title: localization.allFeaturesInOneApp,
              subTitle: localization.coursesMikroTalim,
              imagePath: AppImages.firstOnboarding,
              imageWidthDivider: 1.5,
            ),
            OnboardingWg(
              title: localization.singleAccountAllFeatures,
              subTitle: localization.organishningBarchaFormatlari,
              imagePath: AppImages.secondOnboarding,
              imageWidthDivider: 1.2,
            ),
            OnboardingWg(
              title: localization.allInYourSurround,
              subTitle: localization.sizQandayOrganishniXoxlaysiz,
              imagePath: AppImages.thirdOnboarding,
              imageWidthDivider: 1,
            ),
            OnboardingWg(
              title: localization.learnInDifferentFormats,
              subTitle: localization.bilimniTurliYollar,
              imagePath: AppImages.fourthOnboarding,
              imageWidthDivider: 1.1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: AppColors.white,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: isMobile ? .start : .end,
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
                spacing: 20,
                mainAxisAlignment: isMobile ? .spaceBetween : .end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greyScale.grey50,
                      foregroundColor: AppColors.greyScale.grey600,
                    ),
                    onPressed: () {
                      pageController.jumpToPage(3);
                    },
                    child: AutoSizeText(localization.skipOnboarding),
                  ),
                  ElevatedButton(
                    onPressed: moveNextPage,
                    child: AutoSizeText(
                      isLastPage
                          ? localization.startOnboarding
                          : localization.nextOnboarding,
                    ),
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
