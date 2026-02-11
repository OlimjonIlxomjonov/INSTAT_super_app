import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class MiniAppSectionCard extends StatelessWidget {
  final String mainImage;
  final String backgroundImage;
  final String title;

  const MiniAppSectionCard({
    super.key,
    required this.mainImage,
    required this.backgroundImage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: SvgImageProvider(backgroundImage)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Align(
              child: Image.asset(
                mainImage,
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(title, style: AppTextStyles.source.bold(fontSize: 16)),
        ],
      ),
    );
  }
}
