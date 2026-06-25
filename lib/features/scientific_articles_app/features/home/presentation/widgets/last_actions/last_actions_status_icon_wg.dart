import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

class LastActionsStatusIconWg extends StatelessWidget {
  final LastActionsStatus status;

  const LastActionsStatusIconWg({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LastActionsStatus.accepted:
        return Icon(IconlyBold.tick_square, color: AppColors.greenDoneTaskCard);

      case LastActionsStatus.addedExpert:
        return Icon(IconlyBold.add_user, color: AppColors.orange500);
      case LastActionsStatus.inReview:
        return Icon(IconlyBold.tick_square, color: AppColors.yellow500);
      case LastActionsStatus.rejected:
        return Icon(IconlyBold.info_circle, color: AppColors.red);
      default:
        return Icon(IconlyBold.tick_square, color: AppColors.greenDoneTaskCard);
    }
  }
}

String processTitleSwitch(LastActionsStatus status) {
  switch (status) {
    case LastActionsStatus.inReview:
      return 'Maqola uchun tolov amalga oshirildi';
    case LastActionsStatus.addedExpert:
      return 'Ekspert biriktirildi';
    case LastActionsStatus.rejected:
      return 'Expert tomonidan rad etildi';
    case LastActionsStatus.accepted:
      return 'Ekspert tomonidan tasdiqlandi';
    default:
      return '';
  }
}
