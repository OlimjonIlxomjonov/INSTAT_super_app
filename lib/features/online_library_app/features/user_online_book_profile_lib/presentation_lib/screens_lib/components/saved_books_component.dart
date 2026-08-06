import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/book_actions/book_actions_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/see_all_online_books_component.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_event.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_profile_lib/presentation_lib/bloc/saved_books/saved_books_state.dart';

class SavedBooksComponent extends StatefulWidget {
  const SavedBooksComponent({super.key});

  @override
  State<SavedBooksComponent> createState() => _SavedBooksComponentState();
}

class _SavedBooksComponentState extends State<SavedBooksComponent> {
  @override
  void initState() {
    super.initState();
    context.read<SavedBooksBloc>().add(SavedBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: localization.savedItems),
      body: BlocBuilder<SavedBooksBloc, SavedBooksState>(
        builder: (context, state) {
          if (state is SavedBooksLoading || state is SavedBooksInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedBooksError) {
            return Center(
              child: Text(
                localization.genericError,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey700,
                ),
              ),
            );
          }

          final items = (state as SavedBooksLoaded).response.data;

          // The heart toggle lives in the global BookActionsBloc — once a
          // book is unliked from here (or anywhere else), it should
          // disappear from this list live without needing a refetch.
          final bookActionsState = context.watch<BookActionsBloc>().state;
          final visibleItems = items
              .where(
                (book) =>
                    bookActionsState.isBookSaved(book.id, defaultValue: true),
              )
              .toList();

          if (visibleItems.isEmpty) {
            return Center(
              child: AppEmptyState(
                title: localization.savedBooksEmpty,
                subtitle: localization.savedBooksEmptySubtitle,
                buttonLabel: localization.continueButton,
                onAction: () {
                  FamilyNavigation.familyPush(
                    showHandle: false,
                    context,
                    const SeeAllOnlineBooksComponent(),
                  );
                },
              ),
            );
          }

          return LoadMoreOnScroll(
            // Keyed off the bloc's own paging flags, not visibleItems —
            // unliking a book removes it from the filtered list without
            // changing whether the server has more pages.
            canLoadMore: state.hasMore && !state.isLoadingMore,
            onLoadMore: () => context.read<SavedBooksBloc>().add(
              const LoadMoreSavedBooksEvent(),
            ),
            // Slivers so the spinner sits below the grid rather than
            // occupying a grid cell (which would look like a broken card).
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: appW(20),
                    vertical: appH(16),
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.56,
                        ),
                    itemCount: visibleItems.length,
                    itemBuilder: (context, index) {
                      final book = visibleItems[index];
                      final thumbnail = book.bookThumbnails.isNotEmpty
                          ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${book.bookThumbnails.first.file}'
                          : '';
                      return BookGridItem(
                        id: book.id,
                        isSaved: true,
                        type: BookCardType.market,
                        title: book.name,
                        author: book.author.name,
                        price: "${formatPrice(book.price)} UZS",
                        imagePath: thumbnail.isNotEmpty
                            ? thumbnail
                            : 'assets/images/temp_book.jpg',
                        onTap: () {
                          openMiniAppSheetFamily(
                            context,
                            showHandler: false,
                            child: DetailedOnlineBookComponent(data: book),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (state.isLoadingMore)
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
