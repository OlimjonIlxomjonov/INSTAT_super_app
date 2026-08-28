import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_state.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/detailed_reports_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/utils/app_utils.dart';
import '../filter_bottom_sheet_wg.dart';

class ReportsCardWg extends StatefulWidget {
  const ReportsCardWg({super.key});

  @override
  State<ReportsCardWg> createState() => _ReportsCardWgState();
}

class _ReportsCardWgState extends State<ReportsCardWg> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(ReportsEvent());
  }

  String _formatDateRange(DateTime? from, DateTime? to) {
    if (from == null && to == null) return '—';
    if (from != null && to != null) {
      return '${from.day}.${from.month}.${from.year} – ${to.day}.${to.month}.${to.year}';
    }
    final dt = from ?? to!;
    return '${dt.year}-yil';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return SliverPadding(
      padding: AppPadding.horizontal20x().copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          //! header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localization.reports,
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => showReportsFilterSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconlyLight.filter,
                            size: 14,
                            color: AppColors.greyScale.grey600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            localization.filter,
                            style: AppTextStyles.source.medium(
                              fontSize: 12,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //! body
          BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoaded) {
                final data = state.response.data;

                if (data.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: AppEmptyState(
                      title: 'Hozircha hisobotlar yaratilmagan.',
                      subtitle:
                          'Asosiy samaradorlik ko‘rsatkichlarini kuzatish va natijalarni tahlil qilish uchun birinchi hisobotingizni yarating.',
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = data[index];
                    return _buildReportItem(context, item, localeCode);
                  }, childCount: data.length),
                );
              }

              return Skeletonizer.sliver(
                enabled: true,
                child: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.greyScale.grey50,
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanlanma kuzatuv',
                            style: AppTextStyles.source.medium(
                              fontSize: 11,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aholi sonining yosh bo‘yicha taqsimoti so‘rovnomasi',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.source.medium(fontSize: 13),
                          ),
                          const Spacer(),
                          _buildSectionRows(
                            icon: IconlyLight.location,
                            title: "Respublika bo'yicha",
                          ),
                          const SizedBox(height: 4),
                          _buildSectionRows(
                            icon: IconlyLight.calendar,
                            title: '2025-yil',
                          ),
                          const SizedBox(height: 4),
                          _buildSectionRows(
                            icon: IconlyLight.document,
                            title: '263.09 KB',
                          ),
                        ],
                      ),
                    );
                  }, childCount: 6),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(
    BuildContext context,
    ReportsEntity item,
    String localeCode,
  ) {
    final collectionMethodTitle =
        item.collectionMethod?.localizedTitle(localeCode) ?? '';
    final locationText = item.region ?? "Respublika bo'yicha";
    final dateRangeText = _formatDateRange(
      item.timeCoverageFrom,
      item.timeCoverageTo,
    );

    return GestureDetector(
      onTap: () {
        openMiniAppSheetFamily(
          context,
          showHandler: false,
          child: DetailedReportsPage(item: item),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.greyScale.grey50,
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (collectionMethodTitle.isNotEmpty)
              Text(
                collectionMethodTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.source.medium(
                  fontSize: 12,
                  color: AppColors.primaryColor,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.source.semiBold(
                fontSize: 13,
                color: AppColors.greyScale.grey900,
              ),
            ),
            const Spacer(),
            _buildSectionRows(icon: IconlyLight.location, title: locationText),
            const SizedBox(height: 4),
            _buildSectionRows(icon: IconlyLight.calendar, title: dateRangeText),
            const SizedBox(height: 4),
            _buildSectionRows(
              icon: IconlyLight.document,
              title: formatFileSize(item.filesSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionRows({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.greyScale.grey500, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.source.regular(
              fontSize: 12,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ),
      ],
    );
  }
}
