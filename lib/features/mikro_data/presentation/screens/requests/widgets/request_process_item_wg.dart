import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/process_timeline/process_timeline_item_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_status_icon_wg.dart';

class RequestProcessItemWg extends StatelessWidget {
  const RequestProcessItemWg({
    super.key,
    required this.item,
    required this.isLast,
  });

  final DataRequestProcessEntity item;
  final bool isLast;

  String _statusTitle(AppLocalizations localization) {
    switch (item.processStatus) {
      case MicroDataRequestStatus.accepted:
        return localization.statusConfirmed;
      case MicroDataRequestStatus.rejected:
        return localization.statusRejected;
      case MicroDataRequestStatus.pendingPayment:
        return localization.statusPendingPayment;
      case MicroDataRequestStatus.draft:
        return localization.statusDraft;
      case MicroDataRequestStatus.inReview:
        return localization.statusUnderReview;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ProcessTimelineItemWg(
      icon: LastActionsStatusIconWg(
        status: _timelineStatus(item.processStatus),
      ),
      title: _statusTitle(localization),
      subtitle: item.comment,
      caption: item.user?.fullName,
      date: formatRequestDate(item.createdAt),
      isLast: isLast,
    );
  }

  LastActionsStatus _timelineStatus(MicroDataRequestStatus status) {
    switch (status) {
      case MicroDataRequestStatus.accepted:
        return LastActionsStatus.accepted;
      case MicroDataRequestStatus.rejected:
        return LastActionsStatus.rejected;
      case MicroDataRequestStatus.pendingPayment:
        return LastActionsStatus.addedExpert;
      case MicroDataRequestStatus.draft:
      case MicroDataRequestStatus.inReview:
        return LastActionsStatus.inReview;
    }
  }
}
