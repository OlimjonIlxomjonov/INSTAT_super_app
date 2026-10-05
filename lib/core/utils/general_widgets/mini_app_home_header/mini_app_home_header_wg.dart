import 'package:flutter/material.dart';
import 'package:my_template/core/utils/greeting/time_greeting.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class MiniAppHomeHeaderWg extends StatelessWidget {
  final VoidCallback onTapLeadToPage;

  const MiniAppHomeHeaderWg({super.key, required this.onTapLeadToPage});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: .only(left: appW(20), right: appW(20)),
      sliver: SliverAppBar(
        leading: GestureDetector(
          onTap: onTapLeadToPage,
          child: CircleAvatar(backgroundColor: AppColors.greyScale.grey300),
        ),
        title: GestureDetector(
          onTap: onTapLeadToPage,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                '${timeGreeting(AppLocalizations.of(context)!)} ✌️',
                style: AppTextStyles.source.regular(fontSize: 14),
              ),
              Text(
                'Afzal Pulatov',
                style: AppTextStyles.source.medium(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [Icon(IconlyLight.notification)],
      ),
    );
  }
}
