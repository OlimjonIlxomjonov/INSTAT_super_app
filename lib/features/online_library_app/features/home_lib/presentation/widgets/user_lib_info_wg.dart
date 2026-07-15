import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/widgets/lib_entity_wg.dart';

import '../../../../../../core/utils/app_utils.dart';

class UserLibInfoWg extends StatelessWidget {
  const UserLibInfoWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final cardInfo = getCardInfo(localization);
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          mainAxisExtent: 80,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            padding: const .all(8),
            decoration: BoxDecoration(
              // borderRadius: .circular(12),
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
                  style: AppTextStyles.source.medium(
                    fontSize: 15,
                    color: AppColors.white,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '23',
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
                    Spacer(),
                    SvgPicture.asset(cardInfo[index].iconPath),
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
