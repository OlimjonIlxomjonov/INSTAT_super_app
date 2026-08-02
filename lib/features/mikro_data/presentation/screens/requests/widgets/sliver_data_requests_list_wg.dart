import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_status_check_wg.dart';

class SliverDataRequestsListWg extends StatelessWidget {
  final List<DataRequestEntity> items;

  const SliverDataRequestsListWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final createdAt = item.createdAt.toString().toReadableDate();
          final updatedAt = item.updatedAt.toString().toReadableDate();
          return Container(
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
                  overflow: .ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "ID: ${item.id}",
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      IconlyLight.calendar,
                      color: AppColors.greyScale.grey400,
                    ),
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
          );
        },
      ),
    );
  }
}
