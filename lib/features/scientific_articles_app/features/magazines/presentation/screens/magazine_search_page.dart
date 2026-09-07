import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_editions/article_editions_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/magazines/widgets/sliver_magazine_grid_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Bosh sahifadagi qidiruv shu yerga olib keladi — jurnallar bo'yicha qidiradi.
/// Jurnallar tabidagi ro'yxatga tegmasligi uchun alohida bloc bilan ishlaydi.
class MagazineSearchPage extends StatelessWidget {
  const MagazineSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleEditionsBloc>()
        ..add(
          ArticlesEditionsEvent(
            params: ArticleEditionsParams(status: 'published'),
          ),
        ),
      child: const _MagazineSearchView(),
    );
  }
}

class _MagazineSearchView extends StatefulWidget {
  const _MagazineSearchView();

  @override
  State<_MagazineSearchView> createState() => _MagazineSearchViewState();
}

class _MagazineSearchViewState extends State<_MagazineSearchView> {
  String _search = '';

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
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverDefaultAppBarWg(myTitle: localization.journals, isFamily: true),

          /// SEARCH
          SliverAppBar(
            primary: false,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 80,
            titleSpacing: 20,
            title: AppSearchFieldWg(
              autofocus: true,
              hintText: localization.searchMagazinesHint,
              onChanged: (value) {
                _search = value;
                _fetch();
              },
            ),
          ),

          /// BODY
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
                return SliverOpacity(
                  opacity: state.isRefreshing ? 0.4 : 1,
                  sliver: SliverMagazineGridWg(items: state.response.data),
                );
              } else if (state is ArticleEditionsError) {
                return SliverToBoxAdapter(child: ErrorPage());
              }
              return Skeletonizer.sliver(
                child: SliverMagazineGridWg(
                  items: List.generate(
                    4,
                    (index) =>
                        ArticleEditionsEntity(id: 0, title: 'Loading...'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
