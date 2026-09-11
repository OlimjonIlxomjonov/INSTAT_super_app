import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/module_categories/module_categories_with_bloc.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/wb_blocs/popular_books_with_bloc_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';

class SeeAllOnlineBooksComponent extends StatefulWidget {
  const SeeAllOnlineBooksComponent({super.key});

  @override
  State<SeeAllOnlineBooksComponent> createState() =>
      _SeeAllOnlineBooksComponentState();
}

class _SeeAllOnlineBooksComponentState
    extends State<SeeAllOnlineBooksComponent> {
  String _search = '';
  late int? _categoryId = context.read<PopularBooksBloc>().categoryId;

  @override
  void initState() {
    super.initState();
    if (context.read<PopularBooksBloc>().state is PopularBooksInitial) {
      _fetch();
    }
  }

  void _fetch() {
    context.read<PopularBooksBloc>().add(
      FetchPopularBooksEvent(categoryId: _categoryId, search: _search),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      // Klaviatura ochilganda Scaffold qisqarib, oq fon kitoblarni yopib
      // qo'yadi — offline kutubxona sahifasidagi kabi o'chirilgan.
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<PopularBooksBloc, PopularBooksState>(
        buildWhen: (prev, curr) {
          final p = prev is PopularBooksLoaded ? prev : null;
          final c = curr is PopularBooksLoaded ? curr : null;
          return p?.hasMore != c?.hasMore ||
              p?.isLoadingMore != c?.isLoadingMore;
        },
        builder: (context, state) {
          final loaded = state is PopularBooksLoaded ? state : null;
          return LoadMoreOnScroll(
            canLoadMore:
                (loaded?.hasMore ?? false) && !(loaded?.isLoadingMore ?? false),
            onLoadMore: () => context.read<PopularBooksBloc>().add(
              LoadMorePopularBooksEvent(),
            ),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverDefaultAppBarWg(
                  myTitle: localization.books,
                  isFamily: true,
                ),

                /// SEARCH
                SliverAppBar(
                  primary: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 80,
                  titleSpacing: 20,
                  title: AppSearchFieldWg(
                    onChanged: (value) {
                      _search = value;
                      _fetch();
                    },
                  ),
                ),

                /// CATEGORIES
                SliverToBoxAdapter(
                  child: ModuleCategoriesWithBlocWg(
                    categoryType: 'library',
                    initialSelectedId: _categoryId,
                    onCategorySelected: (categoryId) {
                      _categoryId = categoryId;
                      _fetch();
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverPadding(
                  padding: AppPadding.horizontal20x(),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      localization.books,
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                  ),
                ),

                /// BODY
                const PopularBooksWithBlocWg(),
              ],
            ),
          );
        },
      ),
    );
  }
}
