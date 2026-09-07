import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
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
  String _search = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ArticleEditionsBloc>().add(
      ArticlesEditionsEvent(
        params: ArticleEditionsParams(status: 'published', search: _search),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      // Klaviatura ochilganda oq fon jurnallarni yopib qo'ymasligi uchun.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: AppSearchFieldWg(
          hintText: localization.searchMagazinesHint,
          onChanged: (value) {
            _search = value;
            _fetch();
          },
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
      ),
      body: CustomRefreshIndicator(
        onRefresh: () async => _fetch(),
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: AppPadding.horizontal20x(),
              sliver: SliverToBoxAdapter(
                child: Text(localization.journals, style: CustomTextStyles.h2),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// MAGAZINE  CONTENT GRID
            BlocBuilder<ArticleEditionsBloc, ArticleEditionsState>(
              builder: (context, state) {
                if (state is ArticleEditionsLoaded) {
                  if (state.response.data.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppEmptyState(
                        title: _search.isEmpty
                            ? localization.emptyMagazineShelfTitle
                            : localization.nothingFound,
                        subtitle: _search.isEmpty
                            ? localization.emptyMagazineShelfSubtitle
                            : '',
                      ),
                    );
                  }

                  //! actual data
                  return SliverOpacity(
                    opacity: state.isRefreshing ? 0.4 : 1,
                    sliver: SliverMagazineGridWg(items: state.response.data),
                  );
                } else if (state is ArticleEditionsLoading) {
                  //! loading sate
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
