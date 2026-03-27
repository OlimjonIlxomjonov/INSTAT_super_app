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
    final collapsedMaxHeight = widget.collapsedLines * 22.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: _isExpanded
                ? const BoxConstraints()
                : BoxConstraints(maxHeight: collapsedMaxHeight),
            child: Stack(
              children: [
                // Single Html instance — parsed only once
                _HtmlBody(
                  htmlData: widget.htmlData,
                  fontSize: widget.fontSize,
                  textColor: widget.textColor,
                ),
                // Lightweight gradient fade overlay when collapsed
                if (!_isExpanded)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: collapsedMaxHeight * 0.45,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? "Kamroq ko'rsatish" : "Ko'proq ko'rsatish",
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
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
}

/// Isolated stateless widget so Flutter can skip diffing it when only
/// _isExpanded changes — the Html is never rebuilt unless htmlData changes.
class _HtmlBody extends StatelessWidget {
  final String htmlData;
  final double? fontSize;
  final Color? textColor;

  const _HtmlBody({
    required this.htmlData,
    this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(fontSize ?? 14),
          color: textColor ?? Colors.black,
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
