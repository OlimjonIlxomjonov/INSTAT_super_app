import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/user_articles/user_articles_skeletonizer.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/screens/add_article/add_article_page.dart';

import '../../../../features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import '../../../../features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_state.dart';
import '../../../../features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import '../../../common/ui_states/app_empty_state.dart';
import '../../../common/ui_states/error_page.dart';

class UserArticlesWithBlocWg extends StatelessWidget {
  final int? limit;

  const UserArticlesWithBlocWg({super.key, this.limit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserArticlesBloc, UserArticlesState>(
      builder: (context, state) {
        if (state is UserArticlesLoaded) {
          final data = state.response.data;

          /// empty state
          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: AppEmptyState(
                title: 'Birinchi maqolangizni yozing!',
                subtitle:
                    'Hoziroq boshlang va g‘oyalaringizni dunyoga ulashing.',
                buttonLabel: 'Maqola Qoshish',
                onAction: () {
                  openMiniAppSheetFamily(
                    context,
                    enableDrag: false,
                    showHandler: false,
                    child: AddArticlePage(),
                  );
                },
              ),
            );
          }
          final displayedData = limit != null
              ? data.take(limit!).toList()
              : data;

          /// actual data
          return SliverArticlesListWg(items: displayedData);
        } else if (state is UserArticlesLoading) {
          return UserArticlesSkeletonizer();
        } else if (state is UserArticlesError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(height: 150, child: ErrorPage()),
              ),
            ),
          );
        }
        // Initial or any fallback state
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
