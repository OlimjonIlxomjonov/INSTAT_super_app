import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
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
        return item.thisUser ? Icons.smartphone : IconlyLight.more_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isThisDevice = item.thisUser;
    final accent = AppColors.primaryColor;

    return Container(
      padding: .all(14),
      decoration: BoxDecoration(
        color: isThisDevice ? AppColors.eduCategorySelectedBg : null,
        border: Border.all(
          color: isThisDevice
              ? accent.withValues(alpha: 0.45)
              : AppColors.greyScale.grey200,
        ),
        borderRadius: .circular(12),
      ),
      margin: .only(top: 10),
      child: Row(
        children: [
          //! Device Icon
          CircleAvatar(
            radius: 25,
            backgroundColor: isThisDevice
                ? accent.withValues(alpha: 0.12)
                : AppColors.greyScale.grey200,
            child: Icon(
              _iconGetter(),
              color: isThisDevice ? accent : AppColors.greyScale.grey600,
            ),
          ),
          const SizedBox(width: 15),
          //! Data
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.device,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isThisDevice)
                      _ThisDeviceBadge(accent: accent)
                    else
                      Text(
                        item.lastSeen.toLastSeenText(),
                        style: AppTextStyles.source.medium(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
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

class _ThisDeviceBadge extends StatelessWidget {
  final Color accent;

  const _ThisDeviceBadge({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.iconGreen,
              shape: .circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            AppLocalizations.of(context)!.thisDevice,
            style: AppTextStyles.source.medium(fontSize: 11, color: accent),
          ),
        ],
      ),
    );
  }
}
