import 'package:flutter/material.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../../../../../../core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';

class NotifItemWg extends StatelessWidget {
  final NotifEntity item;

  const NotifItemWg({super.key, required this.item});

  void _openNotification(BuildContext context) {
    subBottomSheetOpener(
      context,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: 120),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.source.medium(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                item.message ?? 'Xabar Bo\'sh',
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
      isExpanded: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openNotification(context),
      child: Container(
        margin: .symmetric(horizontal: 20),
        padding: .all(15),
        decoration: BoxDecoration(
          borderRadius: .circular(10),
          border: Border(
            left: BorderSide(
              width: 5,
              color: item.isRead
                  ? AppColors.greyScale.grey200
                  : AppColors.primaryColor,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              item.title,
              style: AppTextStyles.source.medium(fontSize: 16),
              maxLines: 1,
              overflow: .ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              item.message ?? 'xabar bo\'sh',
              maxLines: 1,
              overflow: .ellipsis,
              style: AppTextStyles.source.regular(
                fontSize: 14,
                color: AppColors.greyScale.grey600,
              ),
            ),
            Divider(color: AppColors.greyScale.grey200),
            Row(
              children: [
                Spacer(),
                Icon(
                  FlutterRemix.calendar_line,
                  size: 15,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 4),
                Text(
                  item.createdAt.toNotificationDateTime(),
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
