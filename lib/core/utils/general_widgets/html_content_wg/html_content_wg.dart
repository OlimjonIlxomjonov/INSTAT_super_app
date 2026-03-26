import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class HtmlContentWg extends StatefulWidget {
  final String htmlData;
  final double? fontSize;
  final Color? textColor;
  final int collapsedLines;

  const HtmlContentWg({
    super.key,
    required this.htmlData,
    this.fontSize,
    this.textColor,
    this.collapsedLines = 4,
  });

  @override
  State<HtmlContentWg> createState() => _HtmlContentWgState();
}

class _HtmlContentWgState extends State<HtmlContentWg> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: Duration(milliseconds: 300),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,

          // Collapsed
          firstChild: IgnorePointer(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
                stops: [0.5, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: widget.collapsedLines * 22.0,
                ),
                child: _buildHtml(),
              ),
            ),
          ),

          // Expanded
          secondChild: _buildHtml(),
        ),

        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: EdgeInsets.only(top: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Kamroq ko\'rsatish' : 'Ko\'proq ko\'rsatish',
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHtml() {
    return Html(
      data: widget.htmlData,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(widget.fontSize ?? 14),
          color: widget.textColor ?? Colors.black,
        ),
        'p': Style(margin: Margins.only(bottom: 8)),
        'strong': Style(fontWeight: FontWeight.bold),
        'h2': Style(
          fontSize: FontSize(18),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 8, top: 8),
        ),
      },
    );
  }
}
