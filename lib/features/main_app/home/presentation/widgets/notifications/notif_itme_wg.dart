import 'package:flutter/material.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';

import '../../../../../../core/utils/app_utils.dart';

class NotifItemWg extends StatelessWidget {
  final NotifEntity item;
  final String timeLabel;
  final VoidCallback? onTap;

  const NotifItemWg({
    super.key,
    required this.item,
    required this.timeLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !item.isRead;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! Vaqt va o'qilmagan belgisi
            Row(
              children: [
                Text(
                  timeLabel,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                const Spacer(),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.medium(
                fontSize: 16,
                color: isUnread
                    ? AppColors.primaryColor
                    : AppColors.greyScale.grey900,
              ),
            ),
            if (item.message != null && item.message!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.message!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
