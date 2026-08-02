import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/last_actions_status_icon_wg.dart';

/// Jarayon qatori — article'dagi LastActionItem bilan bir xil ko'rinishda.
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
    final user = item.user;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: !isLast
              ? BorderSide(color: AppColors.greyScale.grey200)
              : BorderSide.none,
        ),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIMELINE
          Column(
            children: [
              LastActionsStatusIconWg(
                status: _timelineStatus(item.processStatus),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 1,
                  height: 60,
                  color: AppColors.greyScale.grey400,
                ),
            ],
          ),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusTitle(localization),
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),
                if (item.comment.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.comment,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
                if (user != null && user.fullName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.fullName,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey500,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  formatRequestDate(item.createdAt),
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Article'ning ikonka widgeti o'z enum'i bilan ishlaydi — moslashtiramiz.
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
