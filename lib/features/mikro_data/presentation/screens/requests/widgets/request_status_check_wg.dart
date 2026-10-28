import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';

class RequestStatusCheckWg extends StatelessWidget {
  final MicroDataRequestStatus status;
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
    MicroDataRequestStatus.expired => l.expired,
  };

  IconData get _icon => switch (status) {
    MicroDataRequestStatus.draft => IconlyLight.paper,
    MicroDataRequestStatus.inReview => IconlyLight.dangerCircle,
    MicroDataRequestStatus.inProcess => IconlyLight.timeCircle,
    MicroDataRequestStatus.agreementAccepted => IconlyLight.tickSquare,
    MicroDataRequestStatus.headAgreementAccepted => IconlyLight.shieldDone,
    MicroDataRequestStatus.waitingForPayment => IconlyLight.wallet,
    MicroDataRequestStatus.paid => IconlyLight.wallet,
    MicroDataRequestStatus.finished => Icons.check_circle,
    MicroDataRequestStatus.rejected => IconlyLight.dangerCircle,
    MicroDataRequestStatus.unknown => IconlyLight.dangerCircle,
    MicroDataRequestStatus.expired => FlutterRemix.error_warning_line,
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
