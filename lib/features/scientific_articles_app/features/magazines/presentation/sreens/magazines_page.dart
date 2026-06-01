import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/magazine_sources.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/widgets/sliver_magazine_grid_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MagazinesPage extends StatefulWidget {
  const MagazinesPage({super.key});

  @override
  State<MagazinesPage> createState() => _MagazinesPageState();
}

class _MagazinesPageState extends State<MagazinesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticleEditionsBloc>().add(
      ArticlesEditionsEvent(params: ArticleEditionsParams(status: 'published')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Jurnallar'),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<ArticleEditionsBloc>().add(
            ArticlesEditionsEvent(
              params: ArticleEditionsParams(status: 'published'),
            ),
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 56 + 24,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: AppSearchbarWg(),
            ),
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Text('Jurnallar', style: CustomTextStyles.h2),
              ),
            ),

            /// MAGAZINE  CONTENT GRID
            BlocBuilder<ArticleEditionsBloc, ArticleEditionsState>(
              builder: (context, state) {
                if (state is ArticleEditionsLoaded) {
                  if (state.response.data.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          /// empty
                          Text(
                            'Hech qanday Jurnallar mavjud emas!',
                            style: CustomTextStyles.h3half,
                          ),
                          EmptyState(),
                        ],
                      ),
                    );
                  }

                  /// actual data
                  return SliverMagazineGridWg(items: state.response.data);
                } else if (state is ArticleEditionsLoading) {
                  return Skeletonizer.sliver(
                    child: SliverMagazineGridWg(
                      items: List.generate(
                        5,
                        (index) =>
                            ArticleEditionsEntity(id: 0, title: 'Loading...'),
                      ),
                    ),
                  );
                } else if (state is ArticleEditionsError) {
                  return SliverToBoxAdapter(child: ErrorPage());
                }
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
