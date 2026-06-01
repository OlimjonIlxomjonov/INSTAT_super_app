import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

class LastActionsStatusIconWg extends StatelessWidget {
  final LastActionsStatus status;

  const LastActionsStatusIconWg({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LastActionsStatus.sent:
        return Icon(Icons.check_circle, color: AppColors.greenDoneTaskCard);

      case LastActionsStatus.pending:
        return Icon(IconlyBold.edit, color: AppColors.orange500);
      case LastActionsStatus.inReview:
        return Icon(Icons.check_circle, color: AppColors.greenDoneTaskCard);
      default:
        return Icon(Icons.check_circle, color: AppColors.greenDoneTaskCard);
    }
  }
}
