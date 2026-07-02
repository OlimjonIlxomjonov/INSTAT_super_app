import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';
import 'package:my_template/features/onboarding/widgets/onboarding_wg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final ValueNotifier<bool> _isLastPage = ValueNotifier(false);
  late final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    _isLastPage.dispose();
    super.dispose();
  }

  void moveNextPage() {
    if (!_isLastPage.value) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      AppRoute.open(const LogInOptionsPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              AppVectors.firstOnboardingParticles,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: appH(80)),
            child: PageView(
              onPageChanged: (int index) {
                _isLastPage.value = index == 4;
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
                OnboardingWg(
                  title: 'Orzuingizdagi ishni toping',
                  subTitle:
                      'Eng so‘nggi vakansiyalarni ko‘rib chiqing va o‘zingizga mos ishni toping.',
                  imagePath: AppImages.fifthOnboarding,
                  imageWidthDivider: 1,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: ColoredBox(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: isMobile ? .start : .end,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 5,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryColor,
                    expansionFactor: 2,
                    radius: 5,
                    dotHeight: appH(4),
                    dotWidth: appW(10),
                  ),
                ),
                const SizedBox(height: 25),
                ValueListenableBuilder<bool>(
                  valueListenable: _isLastPage,
                  builder: (context, isLast, _) {
                    return Row(
                      spacing: 20,
                      mainAxisAlignment: isMobile
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyScale.grey50,
                            foregroundColor: AppColors.greyScale.grey600,
                          ),
                          onPressed: () => pageController.jumpToPage(4),
                          child: AutoSizeText(localization.skipOnboarding),
                        ),
                        ElevatedButton(
                          onPressed: moveNextPage,
                          child: AutoSizeText(
                            isLast
                                ? localization.startOnboarding
                                : localization.nextOnboarding,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
