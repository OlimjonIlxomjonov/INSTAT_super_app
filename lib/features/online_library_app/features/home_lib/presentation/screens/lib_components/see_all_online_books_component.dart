import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/wb_blocs/popular_books_with_bloc_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class SeeAllOnlineBooksComponent extends StatelessWidget {
  const SeeAllOnlineBooksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      // PopularBooksWithBlocWg builds slivers, so the load-more trigger has
      // to wrap the CustomScrollView from out here.
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
              slivers: [
                SliverDefaultAppBarWg(
                  myTitle: localization.books,
                  isFamily: true,
                ),
                SliverPadding(
                  padding: .symmetric(horizontal: appW(20)),
                  sliver: SliverAppBar(
                    toolbarHeight: 56 + 24,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: AppSearchbarWg(),
                  ),
                ),

                /// CATEGORIES
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 20, bottom: 20),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return EduCategoriesWg();
                      }),
                    ),
                  ),
                ),

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
                PopularBooksWithBlocWg(),
              ],
            ),
          );
        },
      ),
    );
  }
}
