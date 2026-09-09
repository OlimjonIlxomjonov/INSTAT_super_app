import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class ProcessTimelineItemWg extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final String? caption;
  final String date;
  final bool isLast;
  final VoidCallback? onTap;

  const ProcessTimelineItemWg({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    this.subtitle,
    this.caption,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: !isLast
              ? BorderSide(color: AppColors.greyScale.grey200)
              : BorderSide.none,
        ),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //! Timeline
          Column(
            children: [
              icon,
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 1,
                  height: 60,
                  color: AppColors.greyScale.grey400,
                ),
            ],
          ),

          //! Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.source.medium(fontSize: 16)),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
                if (caption != null && caption!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    caption!,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey500,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  date,
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return row;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}
