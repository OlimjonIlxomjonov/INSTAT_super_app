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
      case LastActionsStatus.draft:
        return Icon(IconlyBold.paper, color: AppColors.greyScale.grey500);
      case LastActionsStatus.sent:
        return Icon(IconlyBold.paper_upload, color: AppColors.primaryColor);
      case LastActionsStatus.inReview:
        return Icon(IconlyBold.time_circle, color: AppColors.orange500);
      case LastActionsStatus.inProcess:
        return Icon(IconlyBold.time_circle, color: AppColors.orange500);
      case LastActionsStatus.agreementAccepted:
        return Icon(IconlyBold.tick_square, color: AppColors.greenDoneTaskCard);
      case LastActionsStatus.headAgreementAccepted:
        return Icon(IconlyBold.shield_done, color: AppColors.greenDoneTaskCard);
      case LastActionsStatus.paid:
        return Icon(IconlyBold.wallet, color: AppColors.greenDoneTaskCard);
      case LastActionsStatus.finished:
        return Icon(IconlyBold.tick_square, color: AppColors.greenDoneTaskCard);
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
    case LastActionsStatus.draft:
      return localization.statusDraft;
    case LastActionsStatus.sent:
      return localization.requestSentTitle;
    case LastActionsStatus.inReview:
      return localization.statusUnderReview;
    case LastActionsStatus.inProcess:
      return localization.statusInProcess;
    case LastActionsStatus.agreementAccepted:
      return localization.statusAgreementAccepted;
    case LastActionsStatus.headAgreementAccepted:
      return localization.statusHeadAgreementAccepted;
    case LastActionsStatus.paid:
      return localization.statusPaid;
    case LastActionsStatus.finished:
      return localization.statusFinished;
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
