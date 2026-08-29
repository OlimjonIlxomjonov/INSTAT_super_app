import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';

import '../../../../../../core/utils/app_utils.dart';

class ActiveDevicesWg extends StatelessWidget {
  final ActiveDevicesEntity item;

  const ActiveDevicesWg({super.key, required this.item});

  IconData _iconGetter() {
    switch (item.device) {
      case 'Mac':
        return Icons.laptop;
      default:
        return IconlyLight.more_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      margin: .only(top: 10),
      child: Row(
        children: [
          //! Device Icon
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.greyScale.grey200,
            child: Icon(_iconGetter(), color: AppColors.greyScale.grey600),
          ),
          const SizedBox(width: 15),
          //! Data
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${item.device} ',
                    style: AppTextStyles.source.medium(fontSize: 14),
                    children: [
                      TextSpan(
                        text: item.lastSeen.toLastSeenText(),
                        style: AppTextStyles.source.medium(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  maxLines: 1,
                  overflow: .ellipsis,
                  item.location,
                  style: AppTextStyles.source.medium(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          //! Close
          // Icon(Icons.close, color: AppColors.greyScale.grey700, size: 20),
        ],
      ),
    );
  }
}
