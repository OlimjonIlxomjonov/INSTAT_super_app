import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';

class OnboardingWg extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imagePath;
  final double imageWidthDivider;

  const OnboardingWg({
    super.key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.imageWidthDivider,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final sheetH = size.height / 3.0;
    final fadeH = size.height * 0.20;

    return Responsive(
      mobile: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            // Background image
            Center(
              child: Image.asset(
                imagePath,
                width: size.width / imageWidthDivider,
                fit: BoxFit.contain,
              ),
            ),
            // The fade band
            Positioned(
              left: 0,
              right: 0,
              bottom: sheetH,
              height: fadeH,
              child: const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00FFFFFF),
                        Color(0xD9FFFFFF),
                        Color(0xFFFFFFFF),
                      ],
                      stops: [0.0, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            /// body title & subtitle
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: sheetH,
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.source.bold(fontSize: 30),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subTitle,
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.greyScale.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      tablet: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      imagePath,
                      width: size.width / imageWidthDivider,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // The fade band
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 800,
                    child: const IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00FFFFFF),
                              Color(0xD9FFFFFF),
                              Color(0xFFFFFFFF),
                            ],
                            stops: [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        maxLines: 2,
                        title,
                        maxFontSize: 30,
                        style: AppTextStyles.source.bold(fontSize: 30),
                      ),
                      const SizedBox(height: 12),
                      AutoSizeText(
                        subTitle,
                        maxLines: 2,
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.greyScale.grey500,
                        ),
                      ),
                    ],
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
