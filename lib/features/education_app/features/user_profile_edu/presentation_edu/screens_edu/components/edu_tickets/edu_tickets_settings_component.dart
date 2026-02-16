import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_create_tickets_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_chat_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/tickets_status_switch_case_wg.dart';

class EduTicketsSettingsComponent extends StatelessWidget {
  const EduTicketsSettingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TicketStatus> status = [
      TicketStatus.approved,
      TicketStatus.pending,
      TicketStatus.rejected,
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverDefaultAppBarWg(myTitle: 'Tikketlar'),
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    CustomTabBarWg(
                      firstTab: 'Tasdiqlangan',
                      secondTab: 'Jarayonda',
                      thirdTab: 'Bekor qilingan',
                    ),

                    SizedBox(height: appH(20)),

                    /// SEARCH BAR
                    AppSearchbarWg(),

                    /// BODY
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: List.generate(
                  3,
                  (index) => ListTile(
                    onTap: () {
                      openMiniAppSheet(
                        context,
                        child: EduTicketsChatComponent(),
                      );
                    },
                    minVerticalPadding: 10,
                    shape: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.greyScale.grey200,
                      ),
                    ),
                    titleAlignment: .top,
                    contentPadding: AppPadding.horizontal20x(),
                    title: Text(
                      'Pullik kurslar bo’yicha ba’tafsil ma’lumot',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppTextStyles.source.medium(fontSize: 15),
                    ),
                    subtitle: Text(
                      'Premium kurslar qanday ishlaydi',
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    trailing: ticketsStatusSwitchCase(status[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavContainerWg(
          buttonText: '+  Yangi tikket yaratish',
          onTap: () {
            openMiniAppSheet(context, child: EduCreateTicketsComponent());
          },
        ),
      ),
    );
  }
}
