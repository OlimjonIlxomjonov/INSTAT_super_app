import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

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

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          SvgPicture.asset(AppVectors.firstOnboardingParticles),
          Center(
            child: Image.asset(
              imagePath,
              // height: size.height / 0.4,
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
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.85),
                      Colors.white.withOpacity(1.0),
                    ],
                    stops: [0.0, 0.65, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: sheetH,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.source.bold(fontSize: 30)),
                  SizedBox(height: 12),
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
        ],
      ),
    );
  }
}
