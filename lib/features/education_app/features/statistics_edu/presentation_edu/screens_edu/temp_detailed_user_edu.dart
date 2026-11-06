import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/student_rating/student_rating_cubit.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_achievements_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_info_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/tabs/user_sertificats_tab.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/custom_profile_back.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../widgets_edu/avatar_view_wg.dart';

class TempDetailedUserEdu extends StatelessWidget {
  final int userId;
  final String? imagePath;
  final String name;

  const TempDetailedUserEdu({
    super.key,
    required this.userId,
    required this.imagePath,
    required this.name,
  });

  void _openAvatarViewer(BuildContext context) {
    final ImageProvider image = imagePath != null
        ? NetworkImage(imagePath!)
        : AssetImage(AppImages.profileBackground) as ImageProvider;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: AvatarViewerPage(image: image, heroTag: 'user_avatar'),
        ),
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<StudentRatingCubit>()..load(userId),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: AppPadding.horizontal20x(),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ProfileHeader(
                      background: imagePath != null
                          ? NetworkImage(imagePath!)
                          : AssetImage(AppImages.profileBackground),
                      avatar: imagePath != null
                          ? NetworkImage(imagePath!)
                          : AssetImage(AppImages.profileBackground),
                      heroTag: 'user_avatar',
                      onAvatarTap: () => _openAvatarViewer(context),
                    ),
                    SizedBox(height: appH(12)),
                    Text(
                      name,
                      style: AppTextStyles.source.semiBold(fontSize: 22),
                    ),
                    const _RankLabel(),
                    SizedBox(height: appH(20)),
                    CustomTabBarWg(
                      firstTab: localization.infoTab,
                      secondTab: localization.medalsTab,
                      thirdTab: localization.certificates,
                    ),
                  ],
                ),
              ),
              SizedBox(height: appH(12)),
              const Expanded(
                child: TabBarView(
                  children: [
                    UserInfoTab(),
                    UserAchievementsTab(),
                    UserSertificatsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankLabel extends StatelessWidget {
  const _RankLabel();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final style = AppTextStyles.source.medium(
      fontSize: 14,
      color: AppColors.greyScale.grey600,
    );

    return BlocBuilder<StudentRatingCubit, StudentRatingState>(
      builder: (context, state) {
        final rank = state.data?.rank;
        if (rank == 1) {
          return Text('${localization.champion} 🎖️', style: style);
        }
        return Skeletonizer(
          enabled: state.isLoading,
          child: Text(
            rank == null && !state.isLoading
                ? ''
                : '${localization.rankLabel}: #${rank ?? 10}',
            style: style,
          ),
        );
      },
    );
  }
}
