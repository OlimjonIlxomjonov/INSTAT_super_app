import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';

class UserOnlineBookProfileLib extends StatefulWidget {
  const UserOnlineBookProfileLib({super.key});

  @override
  State<UserOnlineBookProfileLib> createState() =>
      _UserOnlineBookProfileLibState();
}

class _UserOnlineBookProfileLibState extends State<UserOnlineBookProfileLib> {
  late List<IconData> _leadingIcons = [];
  late List<String> _title = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _leadingIcons = [
      IconlyLight.heart,
      IconlyLight.message,
      IconlyLight.location,
      LineIcons.history,
    ];
    _title = [
      'Saqlanganlar',
      'Ko’p beriladigan savollar',
      'Kutubxona manzili',
      'Xaridlar tarixi',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Akkaunt ma’lumotlari'),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: _title.length,
            itemBuilder: (context, index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.greyScale.grey200),
                  ),
                ),
                child: ListTile(
                  onTap: () {},
                  contentPadding: AppPadding.horizontal20x(),
                  leading: Icon(
                    _leadingIcons[index],
                    color: AppColors.greyScale.grey600,
                  ),
                  title: Text(
                    _title[index],
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
            },
          ),
        ],
      ),
    );
  }
}
