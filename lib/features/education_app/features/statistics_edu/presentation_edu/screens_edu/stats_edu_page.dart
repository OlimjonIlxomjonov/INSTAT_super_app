import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/di/service_locator.dart';
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
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/search_students_page.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/temp_detailed_user_edu.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets_edu/top_three_card.dart';

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

  void _openSearch(BuildContext context) {
    // FamilyNavigation.familyPush(
    //   showHandle: false,
    //   context,
    //   BlocProvider(
    //     create: (_) => sl<SearchStudentsBloc>(),
    //     child: const SearchStudentsPage(),
    //   ),
    // );

    openMiniAppSheetFamily(
      showHandler: false,
      context,
      child: BlocProvider(
        create: (_) => sl<SearchStudentsBloc>(),
        child: const SearchStudentsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Foydalanuvchilar'),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<LeaderBoardBloc>().add(LeaderBoardEvent());
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: AppSearchbarWg(onTap: () => _openSearch(context)),
              ),
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
                    children: [
                      // ── Podium for top 3 ──
                      if (data.length >= 3)
                        Skeletonizer(
                          enabled: isLoading,
                          child: TopThreePodium(
                            items: data.sublist(0, 3),
                            fullNames: data
                                .take(3)
                                .map(
                                  (e) =>
                                      '${e.firstName.capitalize()} ${e.lastName.capitalize()}',
                                )
                                .toList(),
                            thumbnails: data
                                .take(3)
                                .map(
                                  (e) => e.avatar != null
                                      ? 'https://test.avacoder.uz${e.avatar}'
                                      : null,
                                )
                                .toList(),
                            onTap: (rank) {
                              final item = data[rank];
                              final String? thumb = item.avatar != null
                                  ? 'https://test.avacoder.uz${item.avatar}'
                                  : null;
                              final name =
                                  '${item.firstName.capitalize()} ${item.lastName.capitalize()}';
                              openMiniAppSheetFamily(
                                context,
                                showHandler: false,
                                child: TempDetailedUserEdu(
                                  imagePath: thumb,
                                  name: name,
                                ),
                              );
                            },
                          ),
                        ),
                      // ── Regular cards for 4th+ ──
                      ...List.generate(data.length, (index) {
                        final item = data[index];
                        final String? thumbnail = item.avatar != null
                            ? 'https://test.avacoder.uz${item.avatar}'
                            : null;
                        final fullName =
                            '${item.firstName.capitalize()} ${item.lastName.capitalize()}';

                        Future<dynamic> onTap() => openMiniAppSheetFamily(
                          context,
                          showHandler: false,
                          child: TempDetailedUserEdu(
                            imagePath: thumbnail,
                            name: fullName,
                          ),
                        );

                        if (index < 3) return const SizedBox.shrink();

                        // Regular card for the rest
                        return GestureDetector(
                          onTap: onTap,
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: appW(20),
                                right: appW(20),
                                bottom: appH(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: appW(12),
                                vertical: appH(8),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.greyScale.grey200,
                                ),
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
                                    backgroundColor:
                                        AppColors.greyScale.grey300,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
