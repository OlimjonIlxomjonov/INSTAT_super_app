import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/user_articles/user_articles_skeletonizer.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';

import '../../../../features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_bloc.dart';
import '../../../../features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_state.dart';
import '../../../../features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';
import '../../../common/ui_states/error_page.dart';

class UserArticlesWithBlocWg extends StatelessWidget {
  final int? limit;

  const UserArticlesWithBlocWg({super.key, this.limit});

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: BlocBuilder<UserArticlesBloc, UserArticlesState>(
        builder: (context, state) {
          if (state is UserArticlesLoaded) {
            final data = state.response.data;

            /// empty state
            if (data.isEmpty) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: EmptyState(message: "message"),
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
      ),
    );
  }
}
