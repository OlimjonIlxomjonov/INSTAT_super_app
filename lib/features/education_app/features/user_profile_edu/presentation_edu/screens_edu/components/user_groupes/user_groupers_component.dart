import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';

class UserGroupersComponent extends StatelessWidget {
  const UserGroupersComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.myGroupsTitle,
          style: AppTextStyles.source.semiBold(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            4,
            (index) => GestureDetector(
              behavior: .opaque,
              onTap: () {
                // FamilyNavigation.familyPush(
                //   context,
                //   DetailedUserGroupComponent(),
                // );
              },
              child: Container(
                margin: .fromLTRB(20, 0, 20, 12),
                padding: .symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: .all(color: AppColors.greyScale.grey200),
                  borderRadius: .circular(16),
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Milliy hisoblar tizimi',
                      style: AppTextStyles.source.medium(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Icon(
                          IconlyLight.calendar,
                          color: AppColors.greyScale.grey600,
                        ),
                        Text('19.02.2025', style: _subStyle()),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          IconlyLight.profile,
                          color: AppColors.greyScale.grey600,
                        ),
                        Text(' User name', style: _subStyle()),
                        SizedBox(width: 10),
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.greyScale.grey600,
                        ),
                        Text('  15/24 tugadi', style: _subStyle()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomLinearIndicatorWg(
                            progressIndicator: 0.4,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('25%', style: _subStyle()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _subStyle() {
    return AppTextStyles.source.regular(
      fontSize: 12,
      color: AppColors.greyScale.grey600,
    );
  }
}
