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
      case LastActionsStatus.sent:
        return Icon(IconlyBold.paper_upload, color: AppColors.primaryColor);
      case LastActionsStatus.inReview:
        return Icon(IconlyBold.time_circle, color: AppColors.orange500);
      case LastActionsStatus.addedExpert:
        return Icon(IconlyBold.add_user, color: AppColors.orange500);
      case LastActionsStatus.waitingForPayment:
        return Icon(IconlyBold.wallet, color: AppColors.yellow500);
      case LastActionsStatus.accepted:
        return Icon(IconlyBold.tick_square, color: AppColors.greenDoneTaskCard);
      case LastActionsStatus.published:
        return Icon(IconlyBold.document, color: AppColors.greenDoneTaskCard);
      case LastActionsStatus.rejected:
        return Icon(IconlyBold.info_circle, color: AppColors.red);
      case LastActionsStatus.unknown:
        return Icon(IconlyBold.info_circle, color: AppColors.greyScale.grey500);
    }
  }
}

/// Backend yuborgan xom status matnini foydalanuvchiga ko'rinadigan sarlavhaga
/// o'giradi. Noma'lum status xom holida chiqadi — noto'g'ri sarlavha
/// ko'rsatgandan ko'ra shunisi aniqroq.
String processTitleSwitch(AppLocalizations localization, String rawStatus) {
  switch (LastActionsStatusX.fromString(rawStatus)) {
    case LastActionsStatus.sent:
      return localization.requestSentTitle;
    case LastActionsStatus.inReview:
      return localization.statusUnderReview;
    case LastActionsStatus.addedExpert:
      return localization.expertAssigned;
    case LastActionsStatus.waitingForPayment:
      return localization.statusWaitingForPayment;
    case LastActionsStatus.accepted:
      return localization.approvedByExpert;
    case LastActionsStatus.published:
      return localization.published;
    case LastActionsStatus.rejected:
      return localization.rejectedByExpert;
    case LastActionsStatus.unknown:
      return rawStatus;
  }
}
