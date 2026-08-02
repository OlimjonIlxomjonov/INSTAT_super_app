import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/add_data_request_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/detail/data_request_detail_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_status_check_wg.dart';

class DataRequestCardWg extends StatelessWidget {
  const DataRequestCardWg({super.key, required this.item, this.onUpdated});

  final DataRequestEntity item;

  final VoidCallback? onUpdated;

  Future<void> _open(BuildContext context) async {
    if (item.requestStatus == MicroDataRequestStatus.draft) {
      await openMiniAppSheetFamily(
        context,
        child: AddDataRequestPage(editRequestId: item.id),
        enableDrag: false,
        showHandler: false,
      );
      onUpdated?.call();
      return;
    }

    await openMiniAppSheetFamily(
      context,
      child: DataRequestDetailPage(
        requestId: item.id,
        status: item.requestStatus,
      ),
      showHandler: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = item.createdAt.toString().toReadableDate();
    final updatedAt = item.updatedAt.toString().toReadableDate();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.description ?? item.fullName,
              style: AppTextStyles.source.medium(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: #${item.id}',
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey400,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(IconlyLight.calendar, color: AppColors.greyScale.grey400),
                const SizedBox(width: 4),
                Text(
                  createdAt == updatedAt ? createdAt : updatedAt,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
                const Spacer(),
                RequestStatusCheckWg(status: item.requestStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
