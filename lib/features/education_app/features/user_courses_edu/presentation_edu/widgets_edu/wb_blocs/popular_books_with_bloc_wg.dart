import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/online_book_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/popular_books/popular_books_state.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';

class PopularBooksWithBlocWg extends StatelessWidget {
  const PopularBooksWithBlocWg({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularBooksBloc, PopularBooksState>(
      builder: (context, state) {
        if (state is PopularBooksLoaded) {
          final data = state.response.data;

          if (data.isEmpty) {
            return SliverToBoxAdapter(child: AppEmptyState(title: ''));
          }

          final grid = SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 16,
                childAspectRatio: 0.52,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final book = data[index];
                logger.f(book.orderCount);
                final average = book.commentCount == 0
                    ? 0.0
                    : book.starsSum / book.commentCount;

                final thumbnail = book.bookThumbnails.isNotEmpty
                    ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${book.bookThumbnails.first.file}'
                    : '';
                return BookGridItem(
                  id: book.id,
                  isSaved: book.isSaved,
                  type: BookCardType.market,
                  title: book.name,
                  author: book.author.name,
                  // oldPrice: '999 UZS',
                  rating: average,
                  price: "\u{00A0}${formatPrice(book.price)} UZS",
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
          );

          if (!state.isLoadingMore) return grid;

          return SliverMainAxisGroup(
            slivers: [
              grid,
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
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
          );
        }
        return SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
