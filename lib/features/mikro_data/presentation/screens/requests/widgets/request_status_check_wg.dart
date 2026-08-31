import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';

class RequestStatusCheckWg extends StatelessWidget {
  final MicroDataRequestStatus status;

  const RequestStatusCheckWg({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (status) {
      case MicroDataRequestStatus.draft:
        return StatusContainerWg(
          icon: IconlyLight.paper,
          statusTitle: ' ${localization.statusDraft}',
          iconColor: AppColors.greyScale.grey700,
          backgroundColor: AppColors.greyNewCard,
        );
      case MicroDataRequestStatus.accepted:
        return StatusContainerWg(
          icon: Icons.check_circle,
          statusTitle: " To'landi",
          iconColor: AppColors.greenDoneTaskCard,
          backgroundColor: AppColors.greenBackground,
        );
      case MicroDataRequestStatus.pendingPayment:
        return StatusContainerWg(
          icon: IconlyLight.wallet,
          statusTitle: ' ${localization.statusPendingPayment}',
          iconColor: AppColors.orange500,
          backgroundColor: AppColors.orange50,
        );
      case MicroDataRequestStatus.rejected:
        return StatusContainerWg(
          icon: IconlyLight.info_circle,
          statusTitle: ' ${localization.statusRejected}',
          iconColor: AppColors.redFailedTaskCard,
          backgroundColor: AppColors.redBackground,
        );
      case MicroDataRequestStatus.inReview:
        return StatusContainerWg(
          icon: IconlyLight.danger,
          statusTitle: ' ${localization.statusUnderReview}',
          iconColor: AppColors.orange500,
          backgroundColor: AppColors.orange50,
        );
    }
  }
}
