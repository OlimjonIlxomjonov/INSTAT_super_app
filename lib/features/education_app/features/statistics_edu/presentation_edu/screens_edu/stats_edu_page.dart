import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board/leader_board_state.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/leader_board_events.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/temp_detailed_user_edu.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsEduPage extends StatefulWidget {
  const StatsEduPage({super.key});

  @override
  State<StatsEduPage> createState() => _StatsEduPageState();
}

class _StatsEduPageState extends State<StatsEduPage> {
  @override
  void initState() {
    super.initState();
    context.read<LeaderBoardBloc>().add(LeaderBoardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Foydalanuvchilar'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(child: AppSearchbarWg()),
          ),

          /// USERS LEADERBOARD
          SliverToBoxAdapter(
            child: BlocBuilder<LeaderBoardBloc, LeaderBoardState>(
              builder: (context, state) {
                final isLoading = state is LeaderBoardLoading;
                final data = state is LeaderBoardLoaded
                    ? state.response.data
                    : List.generate(10, (_) => LeaderBoardEntity.empty());

                return Column(
                  children: List.generate(data.length, (index) {
                    final item = data[index];
                    final String? thumbnail = item.avatar != null
                        ? 'https://test.avacoder.uz${item.avatar}'
                        : null;
                    final fullName = '${item.firstName} ${item.lastName}';
                    return GestureDetector(
                      onTap: () {
                        openMiniAppSheetFamily(
                          context,
                          showHandler: false,
                          child: TempDetailedUserEdu(
                            imagePath: thumbnail,
                            name: fullName,
                          ),
                        );
                      },
                      child: Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          margin: .only(
                            left: appW(20),
                            right: appW(20),
                            bottom: appH(12),
                          ),
                          padding: .symmetric(
                            horizontal: appW(12),
                            vertical: appH(8),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: .circular(12),
                            border: .all(color: AppColors.greyScale.grey200),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '#${index + 1}',
                                style: AppTextStyles.source.regular(
                                  fontSize: 13,
                                  color: AppColors.greyScale.grey600,
                                ),
                              ),
                              SizedBox(width: appW(10)),
                              CircleAvatar(
                                radius: 30,
                                foregroundImage: thumbnail != null
                                    ? NetworkImage(thumbnail)
                                    : null,
                                child: thumbnail == null
                                    ? Icon(
                                        Icons.person,
                                        color: AppColors.greyScale.grey800,
                                        size: 28,
                                      )
                                    : null,
                              ),
                              SizedBox(width: appW(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      fullName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.source.medium(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      item.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.source.regular(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: appW(12)),
                              Text(
                                item.scoreSum.toString(),
                                style: AppTextStyles.source.medium(
                                  fontSize: 13,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                size: 20,
                                color: AppColors.orange,
                              ),
                              SizedBox(width: appW(12)),
                              Icon(IconlyLight.arrow_right_2),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
