import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_bloc.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_event.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/search_students/search_students_state.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/screens_edu/temp_detailed_user_edu.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchStudentsPage extends StatefulWidget {
  const SearchStudentsPage({super.key});

  @override
  State<SearchStudentsPage> createState() => _SearchStudentsPageState();
}

class _SearchStudentsPageState extends State<SearchStudentsPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
    // Fire initial blank search to load all students
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchStudentsBloc>().add(
        SearchStudentsEvent(params: SearchStudentsParams(search: query)),
      );
    });
  }

  void _openDetail(String? avatar, String fullName) {
    final String? thumb = avatar != null
        ? '${ApiUrls.imageUrlBase2}$avatar'
        : null;
    openMiniAppSheetFamily(
      context,
      showHandler: false,
      child: TempDetailedUserEdu(imagePath: thumb, name: fullName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Search Bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appW(16),
                vertical: appH(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appW(14),
                    vertical: appH(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyScale.grey200,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyLight.search,
                        color: AppColors.greyScale.grey600,
                      ),
                      SizedBox(width: appW(8)),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: _search,
                          style: AppTextStyles.source.regular(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: localization.searchUsersHint,
                            hintStyle: AppTextStyles.source.regular(
                              fontSize: 14,
                              color: AppColors.greyScale.grey500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: appH(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: appW(4)),
                      GestureDetector(
                        onTap: () => FamilyNavigation.familyClose(context),
                        child: Text(
                          localization.cancelShort,
                          style: AppTextStyles.source.medium(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ─── Results ──────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<SearchStudentsBloc, SearchStudentsState>(
                builder: (context, state) {
                  final isLoading = state is SearchStudentsLoading;
                  final loaded = state is SearchStudentsLoaded ? state : null;
                  final List<LeaderBoardEntity?> students =
                      state is SearchStudentsLoaded
                      ? state.response.data
                      : (isLoading
                            ? List<LeaderBoardEntity?>.generate(
                                6,
                                (_) => null,
                              ) // skeleton placeholders
                            : const <LeaderBoardEntity?>[]);

                  if (state is SearchStudentsError) {
                    return Center(
                      child: Text(
                        state.isConnectionError
                            ? localization.noInternetConnection
                            : localization.genericError,
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.greyScale.grey700,
                        ),
                      ),
                    );
                  }

                  if (state is SearchStudentsLoaded && students.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconlyLight.search,
                            size: 56,
                            color: AppColors.greyScale.grey400,
                          ),
                          SizedBox(height: appH(16)),
                          Text(
                            localization.nothingFound,
                            style: AppTextStyles.source.medium(
                              fontSize: 16,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return LoadMoreOnScroll(
                    canLoadMore:
                        (loaded?.hasMore ?? false) &&
                        !(loaded?.isLoadingMore ?? false),
                    onLoadMore: () => context.read<SearchStudentsBloc>().add(
                      const LoadMoreSearchStudentsEvent(),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: appW(20)),
                      // One extra slot for the trailing spinner.
                      itemCount:
                          students.length +
                          ((loaded?.isLoadingMore ?? false) ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= students.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          );
                        }
                        final item = students[index];
                        final thumbnail = item?.avatar != null
                            ? '${ApiUrls.imageUrlBase2}${item!.avatar}'
                            : null;
                        final fullName = item?.displayName ?? '';

                        return GestureDetector(
                          onTap: item == null
                              ? null
                              : () => _openDetail(item.avatar, fullName),
                          child: Skeletonizer(
                            enabled: isLoading,
                            child: Container(
                              margin: EdgeInsets.only(bottom: appH(12)),
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
                                          fullName.isEmpty
                                              ? localization.genericUserFallback
                                              : fullName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.source.medium(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          item?.email ??
                                              'placeholder@email.com',
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
                                    (item?.scoreSum ?? 0).toString(),
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
                      },
                    ),
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
