import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/user_articles/user_articles_skeletonizer.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/add_article_page.dart';
import '../../../../../../core/common/ui_states/error_page.dart';
import '../../../../dummy_models/articles_category.dart';
import '../../../home/presentation/bloc/user_articles/user_articles_bloc.dart';
import '../../../home/presentation/bloc/user_articles/user_articles_state.dart';

class UserArticlesPage extends StatefulWidget {
  const UserArticlesPage({super.key});

  @override
  State<UserArticlesPage> createState() => _UserArticlesPageState();
}

class _UserArticlesPageState extends State<UserArticlesPage> {
  int _selectedIndex = 0;
  late UserArticlesBloc _bloc;
  Timer? _debounce;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _bloc.add(
        UserArticlesEvent(status: articleStatus[_selectedIndex], search: query),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = context.read<UserArticlesBloc>();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll < maxScroll - 200) return;

    final state = _bloc.state;
    if (state is! UserArticlesLoaded || !state.canLoadMore) return;

    _bloc.add(
      UserArticlesEvent(
        status: state.status,
        search: state.search,
        page: state.response.metaData.currentPage + 1,
        isLoadMore: true,
      ),
    );
  }

  @override
  void dispose() {
    // only reset if user changed the filter away from 'all'
    if (_selectedIndex != 0) {
      _bloc.add(UserArticlesEvent(status: 'all', search: ''));
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserArticlesBloc>().add(
      UserArticlesEvent(status: articleStatus[_selectedIndex], search: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// header
      appBar: CustomAppBarWg(myTitle: 'Mening maqolalarim'),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<UserArticlesBloc>().add(
            UserArticlesEvent(
              status: articleStatus[_selectedIndex],
              search: '',
            ),
          );
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            /// search bar
            SliverAppBar(
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.greyScale.grey200,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.greyScale.grey600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: AppTextStyles.source.regular(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Maqola qidiring...',
                          hintStyle: AppTextStyles.source.regular(
                            fontSize: 14,
                            color: AppColors.greyScale.grey500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// CATEGORIES
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(right: 20, top: 10),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (index) {
                    return EduCategoriesWg(
                      categoryName: categories[index],
                      isSelected: _selectedIndex == index,
                      onTap: () {
                        if (_selectedIndex == index) return;
                        setState(() => _selectedIndex = index);
                        context.read<UserArticlesBloc>().add(
                          UserArticlesEvent(
                            status: articleStatus[index],
                            search: '',
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),

            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Text('Maqolalar', style: CustomTextStyles.h2),
              ),
            ),

            /// USER ARTICLES
            BlocBuilder<UserArticlesBloc, UserArticlesState>(
              builder: (context, state) {
                if (state is UserArticlesLoaded) {
                  final data = state.response.data;
                  if (data.isEmpty) {
                    return SliverToBoxAdapter(child: EmptyState());
                  }
                  return SliverMainAxisGroup(
                    slivers: [
                      SliverArticlesListWg(items: data),
                      if (state.isLoadingMore)
                        const UserArticlesSkeletonizer(itemCount: 2),
                    ],
                  );
                } else if (state is UserArticlesLoading) {
                  return UserArticlesSkeletonizer();
                } else if (state is UserArticlesError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            ErrorPage(),
                            Text(
                              'Something went wrong!',
                              style: CustomTextStyles.h3half,
                            ),
                            Text(
                              textAlign: .center,
                              'Please check your internet connection and try again!',
                              style: CustomTextStyles.h4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                // Initial or any fallback state
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              FamilyNavigation.familyPush(
                context,
                AddArticlePage(),
                showHandle: false,
              );
            },
            icon: Icon(Icons.add),
            label: Text('Maqola qo’shish'),
          ),
        ),
      ),
    );
  }
}
