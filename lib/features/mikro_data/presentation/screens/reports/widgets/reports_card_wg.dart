import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
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

  String _formatFileExtensions(List options) {
    final extensions =
        options
            .map((opt) {
              final ext = opt.fileExtension;
              if (ext == null || ext.isEmpty) return null;
              return ext.replaceAll('.', '').toUpperCase();
            })
            .whereType<String>()
            .toSet()
            .toList()
          ..sort();

    return extensions.join('/');
  }

  String formatRegionNames(List options, AppLocalizations localization) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final regionNames = options
        .map((opt) => opt.region)
        .whereType<RegionEntity>()
        .map((region) => region.localizedName(localeCode))
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    if (regionNames.isEmpty) return localization.republicOfUzbekistan;
    return regionNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverFillRemaining(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    localization.reports,
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                  InkWell(
                    borderRadius: .circular(6),
                    onTap: () => showReportsFilterSheet(context),
                    child: Container(
                      padding: const .symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: .circular(6),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Text(
                        localization.filter,
                        style: AppTextStyles.source.medium(
                          fontSize: 12,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoaded) {
                    final data = state.response.data;

                    if (data.isEmpty) {
                      return AppEmptyState(
                        title: 'Hozircha hisobotlar yaratilmagan.',
                        subtitle:
                            'Asosiy samaradorlik ko‘rsatkichlarini kuzatish va natijalarni tahlil qilish uchun birinchi hisobotingizni yarating.',
                      );
                    }
                    //! Data
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final categoryName =
                            item.category.localizedName(localeCode).isNotEmpty
                            ? item.category.localizedName(localeCode)
                            : item.category.name;
                        return GestureDetector(
                          onTap: () {
                            openMiniAppSheetFamily(
                              context,
                              showHandler: false,
                              child: DetailedReportsPage(
                                item: item,
                                formatLocation: formatRegionNames,
                              ),
                            );
                          },
                          child: Container(
                            padding: const .all(12),
                            decoration: BoxDecoration(
                              borderRadius: .circular(16),
                              color: AppColors.greyScale.grey50,
                            ),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                if (item.category.nameUz.isNotEmpty) ...[
                                  Text(
                                    categoryName,
                                    style: AppTextStyles.source.medium(
                                      fontSize: 12,
                                      color: AppColors.splashBackgroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: .ellipsis,
                                  style: AppTextStyles.source.medium(
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                _buildSectionRows(
                                  icon: IconlyLight.location,
                                  title: formatRegionNames(
                                    item.options,
                                    localization,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _buildSectionRows(
                                  icon: IconlyLight.time_circle,
                                  title: item.createdAt
                                      .toString()
                                      .toReadableDateWithoutTime(),
                                ),
                                const SizedBox(height: 4),
                                _buildSectionRows(
                                  icon: IconlyLight.document,
                                  title:
                                      "${_formatFileExtensions(item.options)} - ${formatFileSize((double.tryParse(item.fileSize ?? '0') ?? 0).round())}",
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const .all(12),
                          decoration: BoxDecoration(
                            borderRadius: .circular(16),
                            color: AppColors.greyScale.grey50,
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'Category Name',
                                style: AppTextStyles.source.medium(
                                  fontSize: 12,
                                  color: AppColors.splashBackgroundColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Aholi sonining yosh bo‘yicha taqsimoti',
                                maxLines: 2,
                                overflow: .ellipsis,
                                style: AppTextStyles.source.medium(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSectionRows(
                                icon: IconlyLight.location,
                                title: localization.republicOfUzbekistan,
                              ),
                              const SizedBox(height: 4),
                              _buildSectionRows(
                                icon: IconlyLight.time_circle,
                                title: '2021–2024',
                              ),
                              const SizedBox(height: 4),
                              _buildSectionRows(
                                icon: IconlyLight.document,
                                title: 'Excel/PDF — 130MB',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionRows({required IconData icon, required String title}) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, color: AppColors.greyScale.grey600, size: 20),
        Expanded(
          child: Text(
            title,
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
