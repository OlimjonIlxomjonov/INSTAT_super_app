import 'package:flutter/material.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_cubit.dart';
import 'package:my_template/features/main_app/global_search/presentation/bloc/global_search_state.dart';
import 'package:my_template/features/main_app/global_search/presentation/widgets/search_result_tile_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Bitta modul natijasi: sarlavha + 3 tagacha element + "Barchasi".
class SearchGroupWg<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final SearchSection<T> section;
  final String Function(T item) titleBuilder;
  final String Function(T item) subtitleBuilder;
  final void Function(T item) onItemTap;
  final VoidCallback onSeeAll;
  final VoidCallback onRetry;
  final bool isExpanded;

  const SearchGroupWg({
    super.key,
    required this.title,
    required this.icon,
    required this.section,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.onItemTap,
    required this.onSeeAll,
    required this.onRetry,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    //! Bo'sh guruh ko'rinmaydi
    if (section.isEmpty) return const SizedBox.shrink();

    if (section.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, showSeeAll: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionErrorWg(
                title: section.error!.isEmpty ? null : section.error,
                onRetry: onRetry,
              ),
            ),
          ],
        ),
      );
    }

    if (section.isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, showSeeAll: false),
              for (var i = 0; i < 2; i++)
                SearchResultTileWg(
                  icon: icon,
                  title: 'Natija sarlavhasi',
                  subtitle: 'Qo‘shimcha ma’lumot',
                  onTap: () {},
                ),
            ],
          ),
        ),
      );
    }

    final preview = isExpanded
        ? section.items
        : section.items.take(kGlobalSearchPreviewLimit).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, showSeeAll: section.total > preview.length),
          for (final item in preview)
            SearchResultTileWg(
              icon: icon,
              title: titleBuilder(item),
              subtitle: subtitleBuilder(item),
              onTap: () => onItemTap(item),
            ),
          const SizedBox(height: 8),
          Divider(height: 1, color: AppColors.greyScale.grey200),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, {required bool showSeeAll}) {
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.source.semiBold(fontSize: 16),
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                l.seeAll.toUpperCase(),
                style: AppTextStyles.source.medium(
                  fontSize: 13,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
