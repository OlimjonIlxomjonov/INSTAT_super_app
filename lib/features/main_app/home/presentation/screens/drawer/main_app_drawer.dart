import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
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
    return OrientationBuilder(
      builder: (context, orientation) {
        return Drawer(
          backgroundColor: AppColors.white,
          width: double.infinity,
          shape: RoundedRectangleBorder(),
          child: CustomScrollView(
            slivers: [
              /// USER AVATAR
              SliverToBoxAdapter(child: UserAvatarComponent()),

              /// SETTINGS
              SliverToBoxAdapter(child: UserSettingsComponent()),
            ],
          ),
        );
      },
    );
  }
}
