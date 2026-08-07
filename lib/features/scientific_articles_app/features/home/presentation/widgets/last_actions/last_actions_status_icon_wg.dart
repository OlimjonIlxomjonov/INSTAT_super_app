import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
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
      case LastActionsStatus.waitingForPayment:
        return Icon(IconlyBold.wallet, color: AppColors.orange500);
    }
  }
}

String processTitleSwitch(
  AppLocalizations localization,
  LastActionsStatus status,
) {
  switch (status) {
    case LastActionsStatus.inReview:
      return localization.paymentMadeForArticle;
    case LastActionsStatus.addedExpert:
      return localization.expertAssigned;
    case LastActionsStatus.rejected:
      return localization.rejectedByExpert;
    case LastActionsStatus.accepted:
      return localization.approvedByExpert;
    case LastActionsStatus.waitingForPayment:
      return localization.statusWaitingForPayment;
  }
}
