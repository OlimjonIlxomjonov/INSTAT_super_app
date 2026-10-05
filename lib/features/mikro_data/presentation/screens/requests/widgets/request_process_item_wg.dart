import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/process_timeline/process_timeline_item_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';

class RequestProcessItemWg extends StatelessWidget {
  const RequestProcessItemWg({
    super.key,
    required this.item,
    required this.isLast,
  });

  final DataRequestProcessEntity item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ProcessTimelineItemWg(
      icon: Icon(_icon, color: _color),
      title: _title(localization),
      subtitle: item.comment,
      caption: item.user?.fullName,
      date: formatRequestDate(item.createdAt),
      isLast: isLast,
    );
  }

  String _title(AppLocalizations l) => switch (item.processStatus) {
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
    MicroDataRequestStatus.unknown => item.status,
  };

  IconData get _icon => switch (item.processStatus) {
    MicroDataRequestStatus.draft => IconlyBold.paper,
    MicroDataRequestStatus.inReview => IconlyBold.paper_upload,
    MicroDataRequestStatus.inProcess => IconlyBold.time_circle,
    MicroDataRequestStatus.agreementAccepted => IconlyBold.tick_square,
    MicroDataRequestStatus.headAgreementAccepted => IconlyBold.shield_done,
    MicroDataRequestStatus.waitingForPayment => IconlyBold.wallet,
    MicroDataRequestStatus.paid => IconlyBold.wallet,
    MicroDataRequestStatus.finished => IconlyBold.tick_square,
    MicroDataRequestStatus.rejected => IconlyBold.info_circle,
    MicroDataRequestStatus.unknown => IconlyBold.info_circle,
  };

  Color get _color => switch (item.processStatus) {
    MicroDataRequestStatus.paid ||
    MicroDataRequestStatus.finished ||
    MicroDataRequestStatus.agreementAccepted => AppColors.greenDoneTaskCard,
    MicroDataRequestStatus.rejected => AppColors.red,
    MicroDataRequestStatus.waitingForPayment => AppColors.yellow500,
    MicroDataRequestStatus.inReview => AppColors.primaryColor,
    MicroDataRequestStatus.draft ||
    MicroDataRequestStatus.unknown => AppColors.greyScale.grey500,
    _ => AppColors.orange500,
  };
}
