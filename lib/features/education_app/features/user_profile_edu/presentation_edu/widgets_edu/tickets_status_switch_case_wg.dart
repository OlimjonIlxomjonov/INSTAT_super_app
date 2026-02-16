import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';

Widget ticketsStatusSwitchCase(TicketStatus status) {
  switch (status) {
    case TicketStatus.approved:
      return Container(
        padding: .symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.successStatus,
          borderRadius: .circular(6),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.check_circle,
              size: 20,
              color: AppColors.greenDoneTaskCard,
            ),
            Text(
              ' Tasdiqlangan',
              style: AppTextStyles.source.medium(
                fontSize: 12,
                color: AppColors.greenDoneTaskCard,
              ),
            ),
          ],
        ),
      );
    case TicketStatus.pending:
      return Container(
        padding: .symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.waitingStatus,
          borderRadius: .circular(6),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(IconlyBold.danger, size: 20, color: AppColors.orange),
            Text(
              ' Kutilmoqda',
              style: AppTextStyles.source.medium(
                fontSize: 12,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
      );
    case TicketStatus.rejected:
      return Container(
        padding: .symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.declinedStatus,
          borderRadius: .circular(6),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(Icons.dangerous, size: 20, color: AppColors.redFailedTaskCard),
            Text(
              ' Bekor qilingan',
              style: AppTextStyles.source.medium(
                fontSize: 12,
                color: AppColors.redFailedTaskCard,
              ),
            ),
          ],
        ),
      );
    default:
      return SizedBox.shrink();
  }
}
