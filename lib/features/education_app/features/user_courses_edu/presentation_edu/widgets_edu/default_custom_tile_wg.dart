import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class DefaultCustomTileWg extends StatelessWidget {
  final Widget? tileLeading;
  final String? subTitle;
  final String tileTitle;
  final Widget? tileAction;
  final VoidCallback onTap;
  final int? tileMaxLines;
  final TextOverflow? tileOverflow;
  final Color? backgroundColor;
  final Color? borderColor;

  const DefaultCustomTileWg({
    super.key,
    required this.onTap,
    this.tileLeading,
    this.subTitle,
    this.tileAction,
    required this.tileTitle,
    this.tileMaxLines,
    this.tileOverflow,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .symmetric(horizontal: appH(12)),
        margin: .only(bottom: appH(12)),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: .all(color: borderColor ?? AppColors.greyScale.grey200),
          borderRadius: .circular(12),
        ),
        child: ListTile(
          contentPadding: .zero,
          leading: tileLeading,
          title: Text(
            tileTitle,
            maxLines: tileMaxLines,
            overflow: tileOverflow,
            style: AppTextStyles.source.medium(fontSize: 14),
          ),
          trailing: tileAction,
          subtitle: subTitle != null
              ? Text(
                  subTitle!,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
