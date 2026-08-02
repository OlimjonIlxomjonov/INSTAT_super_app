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
import 'package:my_template/core/utils/widgets/search_bar/app_serachbar_wg.dart';
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

class _UserOnlineBooksLibPageState extends State<UserOnlineBooksLibPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBookBloc>().add(UserBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: CustomTabBarWg(
              firstTab: localization.statusInProgress,
              secondTab: localization.finished,
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
                  (loaded?.hasMore ?? false) &&
                  !(loaded?.isLoadingMore ?? false),
              onLoadMore: () => context.read<UserBookBloc>().add(
                const LoadMoreUserBooksEvent(),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    primary: false,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    title: AppSearchbarWg(),
                  ),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(right: 20, top: 20),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(5, (index) {
                          return EduCategoriesWg();
                        }),
                      ),
                    ),
                  ),

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
                        if (data.isEmpty) {
                          return SliverToBoxAdapter(
                            child: AppEmptyState(
                              title: 'Javoningiz bo‘sh',
                              subtitle:
                                  'Xarid qilingan kitoblaringiz shu yerda ko‘rinadi.',
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
      ),
    );
  }
}
