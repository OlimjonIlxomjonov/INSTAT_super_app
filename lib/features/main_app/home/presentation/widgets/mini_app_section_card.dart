import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:svg_image_provider/svg_image_provider.dart';

class MiniAppSectionCard extends StatefulWidget {
  final String mainImage;
  final String backgroundImage;
  final String title;
  final void Function(BuildContext context) onTap;
  final VoidCallback onLongPress;
  final bool isCollapsed;

  const MiniAppSectionCard({
    super.key,
    required this.mainImage,
    required this.backgroundImage,
    required this.title,
    required this.onTap,
    required this.onLongPress,
    required this.isCollapsed,
  });

  @override
  State<MiniAppSectionCard> createState() => _MiniAppSectionCardState();
}

class _MiniAppSectionCardState extends State<MiniAppSectionCard> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double? getSize = isMobile ? 140 : null;

    return GestureDetector(
      onTap: () => widget.onTap(context),
      onLongPress: widget.onLongPress,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: SvgImageProvider(
              widget.backgroundImage,
              containerSize: isMobile ? null : Size(170, 170),
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                widget.mainImage,
                width: getSize,
                height: getSize,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              widget.title,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: AppTextStyles.source.medium(
                fontSize: widget.isCollapsed ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
