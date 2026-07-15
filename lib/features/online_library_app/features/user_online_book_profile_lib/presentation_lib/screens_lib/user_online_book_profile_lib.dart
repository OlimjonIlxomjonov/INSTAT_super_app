import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/screens_lib/components/saved_books_component.dart';

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
    final localization = AppLocalizations.of(context)!;
    _leadingIcons = [
      IconlyLight.heart,
      IconlyLight.chat,
      IconlyLight.location,
      LineIcons.history,
    ];
    _title = [
      localization.savedItems,
      localization.frQuestions,
      localization.libraryAddress,
      localization.purchaseHistory,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(
        myTitle: localization.accountInfo,
        showArrow: false,
        centerTitle: false,
      ),
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
                  onTap: () => _navigateTo(index),
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

  void _navigateTo(int index) {
    switch (index) {
      case 0:
        openMiniAppSheetFamily(
          context,
          child: SavedBooksComponent(),
          showHandler: false,
        );
      default:
        errorFlushBar(context, AppLocalizations.of(context)!.comingSoon);
    }
  }
}
