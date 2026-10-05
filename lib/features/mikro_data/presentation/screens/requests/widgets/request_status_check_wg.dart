import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';

class RequestStatusCheckWg extends StatelessWidget {
  final MicroDataRequestStatus status;

  /// Noma'lum status kelganda xom matnni ko'rsatish uchun.
  final String rawStatus;

  const RequestStatusCheckWg({
    super.key,
    required this.status,
    this.rawStatus = '',
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return StatusContainerWg(
      icon: _icon,
      statusTitle: ' ${_title(localization)}',
      iconColor: _color,
      backgroundColor: _background,
    );
  }

  String _title(AppLocalizations l) => switch (status) {
    MicroDataRequestStatus.draft => l.statusDraft,
    MicroDataRequestStatus.inReview => l.statusUnderReview,
    MicroDataRequestStatus.inProcess => l.statusInProcess,
    MicroDataRequestStatus.agreementAccepted => l.statusAgreementAccepted,
    MicroDataRequestStatus.headAgreementAccepted =>
      l.statusHeadAgreementAccepted,
    MicroDataRequestStatus.waitingForPayment => l.statusWaitingForPayment,
    MicroDataRequestStatus.paid => l.statusPaid,
    MicroDataRequestStatus.finished => l.statusFinished,
    MicroDataRequestStatus.rejected => l.statusRejected,
    MicroDataRequestStatus.unknown =>
      rawStatus.isEmpty ? l.statusDraft : rawStatus,
  };

  IconData get _icon => switch (status) {
    MicroDataRequestStatus.draft => IconlyLight.paper,
    MicroDataRequestStatus.inReview => IconlyLight.danger,
    MicroDataRequestStatus.inProcess => IconlyLight.time_circle,
    MicroDataRequestStatus.agreementAccepted => IconlyLight.tick_square,
    MicroDataRequestStatus.headAgreementAccepted => IconlyLight.shield_done,
    MicroDataRequestStatus.waitingForPayment => IconlyLight.wallet,
    MicroDataRequestStatus.paid => IconlyLight.wallet,
    MicroDataRequestStatus.finished => Icons.check_circle,
    MicroDataRequestStatus.rejected => IconlyLight.info_circle,
    MicroDataRequestStatus.unknown => IconlyLight.info_circle,
  };

  Color get _color => switch (status) {
    MicroDataRequestStatus.paid ||
    MicroDataRequestStatus.finished => AppColors.greenDoneTaskCard,
    MicroDataRequestStatus.rejected => AppColors.redFailedTaskCard,
    MicroDataRequestStatus.draft ||
    MicroDataRequestStatus.unknown => AppColors.greyScale.grey700,
    _ => AppColors.orange500,
  };

  Color get _background => switch (status) {
    MicroDataRequestStatus.paid ||
    MicroDataRequestStatus.finished => AppColors.greenBackground,
    MicroDataRequestStatus.rejected => AppColors.redBackground,
    MicroDataRequestStatus.draft ||
    MicroDataRequestStatus.unknown => AppColors.greyNewCard,
    _ => AppColors.orange50,
  };
}
