import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

class UserOnlineBookProfileLib extends StatelessWidget {
  const UserOnlineBookProfileLib({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> leadingIcons = [
      IconlyLight.heart,
      IconlyLight.message,
      IconlyLight.location,
      LineIcons.history,
    ];
    final List<String> title = [
      'Saqlanganlar',
      'Ko’p beriladigan savollar',
      'Kutubxona manzili',
      'Xaridlar tarixi',
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: AppPadding.hAndV20x20(),
                  child: Text(
                    'Akkaunt ma’lumotlari',
                    style: AppTextStyles.source.medium(fontSize: 17),
                  ),
                ),
                ...List.generate(4, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.greyScale.grey200),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {},
                      contentPadding: AppPadding.horizontal20x(),
                      leading: Icon(
                        leadingIcons[index],
                        color: AppColors.greyScale.grey600,
                      ),
                      title: Text(
                        title[index],
                        style: AppTextStyles.source.medium(
                          fontSize: 15,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                      trailing: Icon(
                        IconlyLight.arrow_right_2,
                        size: 20,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
