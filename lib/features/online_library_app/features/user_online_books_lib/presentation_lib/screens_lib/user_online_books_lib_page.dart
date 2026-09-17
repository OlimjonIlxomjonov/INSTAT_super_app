import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/common/ui_states/app_empty_state.dart';
import '../../../../../../core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import '../../../home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class UserOnlineBooksLibPage extends StatefulWidget {
  const UserOnlineBooksLibPage({super.key});

  @override
  State<UserOnlineBooksLibPage> createState() => _UserOnlineBooksLibPageState();
}

class _UserOnlineBooksLibPageState extends State<UserOnlineBooksLibPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final UserBookBloc _bloc = context.read<UserBookBloc>();
  String _search = '';

  UserBookType get _type => UserBookType.values[_tabController.index];

  bool get _isFiltering => _search.isNotEmpty || _type != UserBookType.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: UserBookType.values.length,
      vsync: this,
    )..addListener(_onTabChanged);
    _fetch();
  }

  @override
  void dispose() {
    // The bloc is shared with the home page's "active books" section — don't
    // leave it holding this page's tab / search.
    if (_isFiltering) _bloc.add(const UserBooksEvent());
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Fires once per switch (not on every animation frame).
    if (_tabController.indexIsChanging) return;
    _fetch();
  }

  void _fetch() {
    _bloc.add(UserBooksEvent(type: _type, search: _search));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      // Klaviatura ochilganda oq fon kitoblarni yopib qo'ymasligi uchun.
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: CustomTabBarWg(
            controller: _tabController,
            firstTab: AppLocalizations.of(context)!.categoryAll,
            secondTab: AppLocalizations.of(context)!.onlineBooksTab,
            thirdTab: AppLocalizations.of(context)!.paperBooksTab,
          ),
        ),
      ),
      body: BlocBuilder<UserBookBloc, UserBookState>(
        buildWhen: (prev, curr) {
          final p = prev is UserBookLoaded ? prev : null;
          final c = curr is UserBookLoaded ? curr : null;
          return p?.hasMore != c?.hasMore ||
              p?.isLoadingMore != c?.isLoadingMore;
        },
        builder: (context, pagingState) {
          final loaded = pagingState is UserBookLoaded ? pagingState : null;
          return LoadMoreOnScroll(
            canLoadMore:
                (loaded?.hasMore ?? false) && !(loaded?.isLoadingMore ?? false),
            onLoadMore: () => context.read<UserBookBloc>().add(
              const LoadMoreUserBooksEvent(),
            ),
            child: CustomScrollView(
              slivers: [
                //! Search
                SliverAppBar(
                  primary: false,
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  title: AppSearchFieldWg(
                    hintText: localization.searchBooksHint,
                    onChanged: (value) {
                      if (value == _search) return;
                      _search = value;
                      _fetch();
                    },
                  ),
                ),
                //! Title
                SliverPadding(
                  padding: .only(left: 20, top: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      localization.myBooks,
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                  ),
                ),
                BlocBuilder<UserBookBloc, UserBookState>(
                  builder: (context, state) {
                    if (state is UserBookLoaded) {
                      final data = state.response.data;
                      //! Empty State
                      if (data.isEmpty) {
                        return SliverToBoxAdapter(
                          child: _isFiltering
                              ? AppEmptyState(title: localization.booksNotFound)
                              : AppEmptyState(
                                  title: localization.myShelfEmptyTitle,
                                  subtitle: localization.myShelfEmptySubtitle,
                                ),
                        );
                      }

                      return SliverPadding(
                        padding: AppPadding.hAndV20x20(),
                        sliver: SliverGrid.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.53,
                              ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            final thumbnail = item.bookThumbnails.first.file;
                            final progress = item.pagesCount > 0
                                ? (item.currentPage / item.pagesCount).clamp(
                                    0.0,
                                    1.0,
                                  )
                                : 0.0;
                            //! Data
                            return BookGridItem(
                              type: BookCardType.bought,
                              title: item.name,
                              author: item.author.name,
                              progress: progress,
                              currentPage: item.currentPage,
                              totalPages: item.pagesCount,
                              imagePath: '${ApiUrls.imageUrlBase}$thumbnail',
                              onTap: () {
                                openMiniAppSheetFamily(
                                  context,
                                  showHandler: false,
                                  child: DetailedOnlineBookComponent(
                                    isBookBought: true,
                                    data: item,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: AppPadding.hAndV20x20(),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.53,
                            ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: true,
                            child: BookGridItem(
                              type: BookCardType.bought,
                              title: "Jajji shahzoda",
                              author: "Antuan de Sent-Ekzyuperi",
                              progress: 0.75,
                              currentPage: 122,
                              totalPages: 354,
                              imagePath: 'assets/images/temp_book.jpg',
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                if (loaded?.isLoadingMore ?? false)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
