import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
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

    return GestureDetector(
      onTap: () => onTap(context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.none,
            alignment: .centerRight,
            image: SvgImageProvider(backgroundImage),
          ),
          borderRadius: .circular(16),
          gradient: LinearGradient(colors: colors),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    maxLines: 2,
                    title,
                    overflow: .ellipsis,
                    style: AppTextStyles.source.semiBold(
                      fontSize: 15,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: .bottomRight,
                child: Image.asset(
                  mainImage,
                  fit: BoxFit.cover,
                  width: 75,
                  height: 75,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
