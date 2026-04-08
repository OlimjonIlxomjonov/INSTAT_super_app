import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class MiniAppSectionCard extends StatelessWidget {
  final String mainImage;
  final String backgroundImage;
  final List<Color> colors;
  final String title;
  final void Function(BuildContext context) onTap;

  const MiniAppSectionCard({
    super.key,
    required this.mainImage,
    required this.backgroundImage,
    required this.title,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return GestureDetector(
      onTap: () => onTap(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: .centerRight,
            image: SvgImageProvider(backgroundImage),
          ),
          borderRadius: .circular(16),
          gradient: LinearGradient(colors: colors),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  maxLines: 2,
                  title,
                  overflow: .ellipsis,
                  style: AppTextStyles.source.semiBold(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
