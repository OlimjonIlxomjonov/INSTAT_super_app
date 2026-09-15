import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/library_stats/library_stats_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/widgets/lib_entity_wg.dart';

import '../../../../../../core/utils/app_utils.dart';

class UserLibInfoWg extends StatelessWidget {
  final int index;
  final LibraryStatsEntity? item;
  final bool isError;

  const UserLibInfoWg({
    super.key,
    required this.index,
    required this.item,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      item?.allOnline ?? 0,
      item?.saved ?? 0,
      item?.loans ?? 0,
      item?.activeLoans ?? 0,
    ];

    final localization = AppLocalizations.of(context)!;
    final cardInfo = getCardInfo(localization);
    return Container(
      padding: const .all(8),
      decoration: BoxDecoration(
        borderRadius: .only(
          topLeft: .circular(index == 3 ? 0 : 12),
          topRight: .circular(index == 2 ? 0 : 12),
          bottomLeft: .circular(index == 1 ? 0 : 12),
          bottomRight: .circular(index == 0 ? 0 : 12),
        ),
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: cardInfo[index].backColors,
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            cardInfo[index].cardName,
            maxLines: 1,
            overflow: .ellipsis,
            style: AppTextStyles.source.medium(
              fontSize: 15,
              color: AppColors.white,
            ),
          ),
          Row(
            children: [
              if (isError)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'err',
                    style: AppTextStyles.source.semiBold(
                      fontSize: 16,
                      color: AppColors.redFailedTaskCard,
                    ),
                  ),
                )
              else ...[
                Text(
                  items[index].toString(),
                  style: AppTextStyles.source.medium(
                    fontSize: 20,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  localization.unitsSuffix,
                  style: AppTextStyles.source.medium(
                    fontSize: 14,
                    color: AppColors.greyScale.grey300,
                  ),
                ),
              ],
              Spacer(),
              SvgPicture.asset(cardInfo[index].iconPath),
            ],
          ),
        ],
      ),
    );
  }
}
