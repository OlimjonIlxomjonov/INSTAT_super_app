import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/report_options_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/report_options_state.dart';

class DetailedReportsPage extends StatelessWidget {
  final ReportsEntity item;
  final String Function(List<dynamic>, AppLocalizations) formatLocation;

  const DetailedReportsPage({
    super.key,
    required this.item,
    required this.formatLocation,
  });

  String _formatPrice(String? priceStr) {
    if (priceStr == null || priceStr.isEmpty) return 'Bepul';
    final doubleVal = double.tryParse(priceStr) ?? 0;
    if (doubleVal == 0) return 'Bepul';
    final intVal = doubleVal.round();
    final formatted = intVal.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
    return '$formatted so‘m';
  }

  String _formatDateRange(DateTime dateFrom, DateTime dateTo) {
    String formatSingle(DateTime dt) {
      final y = dt.year;
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$d.$m.$y';
    }

    return '${formatSingle(dateFrom)} – ${formatSingle(dateTo)}';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final categoryName = item.category.localizedName(localeCode).isNotEmpty
        ? item.category.localizedName(localeCode)
        : item.category.name;

    return BlocProvider<ReportOptionsBloc>(
      create: (_) =>
          sl<ReportOptionsBloc>()
            ..add(FetchReportOptionsEvent(reportId: item.id)),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //! Header
            const SliverAppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: SheetDragAreaWg(
                child: CustomAppBarWg(myTitle: "Hisobot ma'lumotlari"),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            //! Title
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  item.name,
                  style: AppTextStyles.source.semiBold(fontSize: 18),
                ),
              ),
            ),

            //! Description
            if (item.description != null && item.description!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, appH(16), 20, 0),
                  child: RepaintBoundary(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: HtmlContentWg(
                          fontSize: 15,
                          textColor: AppColors.greyScale.grey700,
                          collapsedLines: 10,
                          htmlData: item.description!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            //! Options List / Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<ReportOptionsBloc, ReportOptionsState>(
                  builder: (context, state) {
                    List<ReportsOptionsEntity> displayOptions = item.options;
                    bool isLoading = state is ReportOptionsLoading;

                    if (state is ReportOptionsLoaded &&
                        state.options.isNotEmpty) {
                      displayOptions = state.options;
                    }

                    if (isLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: Column(
                          children: List.generate(
                            item.options.isEmpty ? 1 : item.options.length,
                            (index) => _buildSkeletonCard(categoryName),
                          ),
                        ),
                      );
                    }

                    if (displayOptions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.greyScale.grey50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.greyScale.grey200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryName,
                              style: AppTextStyles.source.medium(
                                fontSize: 13,
                                color: AppColors.splashBackgroundColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailField(
                              label: 'Hudud viloyatlar',
                              value: formatLocation(item.options, localization),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: List.generate(displayOptions.length, (index) {
                        final opt = displayOptions[index];
                        return _buildOptionCard(
                          context,
                          option: opt,
                          index: index,
                          totalCount: displayOptions.length,
                          categoryName: categoryName,
                          localeCode: localeCode,
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required ReportsOptionsEntity option,
    required int index,
    required int totalCount,
    required String categoryName,
    required String localeCode,
  }) {
    final regionName =
        option.region?.localizedName(localeCode) ?? 'O‘zbekiston Respublikasi';
    final districtName = option.district?.localizedName(localeCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (totalCount > 1) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (option.fileExtension.isNotEmpty)
                  Text(
                    option.fileExtension.replaceAll('.', '').toUpperCase(),
                    style: AppTextStyles.source.semiBold(
                      fontSize: 12,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Category Name
          Text(
            categoryName,
            style: AppTextStyles.source.medium(
              fontSize: 13,
              color: AppColors.splashBackgroundColor,
            ),
          ),
          const SizedBox(height: 12),

          // Hudud viloyat
          _buildDetailField(label: 'Hudud viloyatlar', value: regionName),
          const SizedBox(height: 12),

          // Hudud tuman (if present)
          if (districtName != null && districtName.isNotEmpty) ...[
            _buildDetailField(label: 'Hudud tumanlar', value: districtName),
            const SizedBox(height: 12),
          ],

          // Kategoriya
          _buildDetailField(label: 'Kategoriya', value: categoryName),
          const SizedBox(height: 12),

          // Davr oraliq
          _buildDetailField(
            label: 'Davr oraliq',
            value: _formatDateRange(option.dateFrom, option.dateTo),
          ),

          // File Info (if file size exists)
          if (option.fileSize != null) ...[
            const SizedBox(height: 12),
            _buildDetailField(
              label: 'Fayl hajmi',
              value:
                  '${option.fileExtension.replaceAll('.', '').toUpperCase()} — ${formatFileSize((double.tryParse(option.fileSize.toString()) ?? 0).round())}',
            ),
          ],

          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.greyScale.grey200),
          const SizedBox(height: 16),

          // Price & Download action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Narxi',
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(option.price),
                    style: AppTextStyles.source.medium(
                      fontSize: 16,
                      color: AppColors.greyScale.grey900,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  // if (option.file != null && option.file!.isNotEmpty) {
                  //   final uri = Uri.parse(option.file!);
                  //   if (await canLaunchUrl(uri)) {
                  //     await launchUrl(
                  //       uri,
                  //       mode: LaunchMode.externalApplication,
                  //     );
                  //   }
                  // }
                  technicalWorkFlushBar(context, 'Tez orada!');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Yuklab olish',
                  style: AppTextStyles.source.medium(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard(String categoryName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(categoryName),
          const SizedBox(height: 12),
          _buildDetailField(
            label: 'Hudud viloyatlar',
            value: 'Andijon viloyati',
          ),
          const SizedBox(height: 12),
          _buildDetailField(label: 'Hudud tumanlar', value: 'Asaka tumani'),
          const SizedBox(height: 12),
          _buildDetailField(label: 'Kategoriya', value: categoryName),
          const SizedBox(height: 12),
          _buildDetailField(
            label: 'Davr oraliq',
            value: '01.08.2026 – 31.08.2026',
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.greyScale.grey200),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const Text('Narxi'), const Text('200.000 so\'m')],
              ),
              const ElevatedButton(
                onPressed: null,
                child: Text('Yuklab olish'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.source.semiBold(
            fontSize: 15,
            color: AppColors.greyScale.grey900,
          ),
        ),
      ],
    );
  }
}
