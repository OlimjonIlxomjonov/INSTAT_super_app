import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class MiniAppSectionCard extends StatefulWidget {
  final String mainImage;
  final String backgroundImage;
  final String title;
  final void Function(BuildContext context) onTap;

  const MiniAppSectionCard({
    super.key,
    required this.mainImage,
    required this.backgroundImage,
    required this.title,
    required this.onTap,
  });

  @override
  State<MiniAppSectionCard> createState() => _MiniAppSectionCardState();
}

class _MiniAppSectionCardState extends State<MiniAppSectionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(context),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: SvgImageProvider(
              widget.backgroundImage,
              // containerSize: Size(300, 300),
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                widget.mainImage,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              widget.title,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: AppTextStyles.source.medium(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
