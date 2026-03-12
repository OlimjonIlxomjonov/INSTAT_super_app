import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_sheet.dart';
import 'package:my_template/core/utils/widgets/profile_settings_tile/profile_settings_tile_wg.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/app_language_settings_model_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_settings_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/notification_settings_edu_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/dot_swtich_wg.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/user_avatar_component.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/user_settings_component.dart';

class MainAppDrawer extends StatefulWidget {
  const MainAppDrawer({super.key});

  @override
  State<MainAppDrawer> createState() => _MainAppDrawerState();
}

class _MainAppDrawerState extends State<MainAppDrawer> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        return Drawer(
          backgroundColor: AppColors.white,
          width: double.infinity,
          shape: RoundedRectangleBorder(),
          child: Responsive(
            mobile: CustomScrollView(
              slivers: [
                /// HEADER
                // SliverDefaultAppBarWg(),

                /// USER AVATAR
                SliverToBoxAdapter(child: UserAvatarComponent()),

                /// SETTINGS
                SliverToBoxAdapter(child: UserSettingsComponent()),
              ],
            ),
            tablet: isPortrait
                ? Column(
                    children: [UserAvatarComponent(), UserSettingsComponent()],
                  )
                : Row(
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(child: UserAvatarComponent()),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: UserSettingsComponent(),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
