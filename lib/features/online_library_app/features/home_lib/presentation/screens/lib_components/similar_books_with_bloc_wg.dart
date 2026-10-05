import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/similar_book/similar_book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/similar_books/similar_books_cubit.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/detailed_online_book_component.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SimilarBooksWithBlocWg extends StatelessWidget {
  final int bookId;

  const SimilarBooksWithBlocWg({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocBuilder<SimilarBooksCubit, SimilarBooksState>(
      builder: (context, state) {
        if (state is SimilarBooksError) {
          return Padding(
            padding: AppPadding.horizontal20x(),
            child: SectionErrorWg(
              title: state.message,
              onRetry: () => context.read<SimilarBooksCubit>().load(bookId),
            ),
          );
        }

        //! Bo'sh bo'lsa bo'lim ko'rinmaydi
        if (state is SimilarBooksLoaded && state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final loaded = state is SimilarBooksLoaded ? state : null;
        final items = loaded?.items ?? _skeletonItems;

        return Skeletonizer(
          enabled: loaded == null,
          child: SizedBox(
            height: 128,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: AppPadding.horizontal20x(),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final item = items[index];
                return _SimilarBookCard(
                  item: item,
                  isOpening: loaded?.openingId == item.id,
                  onTap: () => context.read<SimilarBooksCubit>().openBook(
                    item.id,
                    onLoaded: (book) => openMiniAppSheetFamily(
                      context,
                      showHandler: false,
                      child: DetailedOnlineBookComponent(data: book),
                    ),
                    onError: (message) =>
                        errorFlushBar(context, message ?? l.sectionLoadError),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SimilarBookCard extends StatelessWidget {
  final SimilarBookEntity item;
  final bool isOpening;
  final VoidCallback onTap;

  const _SimilarBookCard({
    required this.item,
    required this.isOpening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isOpening ? null : onTap,
      child: Container(
        width: 190,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              FlutterRemix.book_2_line,
              size: 22,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                item.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.source.medium(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            if (isOpening)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }
}

//! Skeleton uchun
const _skeletonItems = [
  SimilarBookEntity(id: 0, name: 'Kitob nomi bu yerda ikki qatorda turadi'),
  SimilarBookEntity(id: 1, name: 'Yana bitta kitob nomi'),
  SimilarBookEntity(id: 2, name: 'Uchinchi kitob nomi'),
];
