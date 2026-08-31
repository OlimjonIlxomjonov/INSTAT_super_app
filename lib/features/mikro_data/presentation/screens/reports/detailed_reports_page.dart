import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_files/report_files_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_files/report_files_stat.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_variables/report_variables_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/report_variables/report_variables_state.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/l10n/app_localizations.dart';

class DetailedReportsPage extends StatefulWidget {
  final ReportsEntity item;

  const DetailedReportsPage({super.key, required this.item});

  @override
  State<DetailedReportsPage> createState() => _DetailedReportsPageState();
}

class _DetailedReportsPageState extends State<DetailedReportsPage> {
  final ValueNotifier<bool> _isOpeningFile = ValueNotifier(false);

  @override
  void dispose() {
    _isOpeningFile.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$d.$m.$y';
  }

  String _formatCoverage(double? coverage) {
    if (coverage == null) return '—';
    final intVal = coverage.round();
    return intVal.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]} ',
    );
  }

  Future<void> _openFile(String? url, {String? fileName}) async {
    if (url == null || url.isEmpty) {
      if (mounted) {
        errorFlushBar(context, AppLocalizations.of(context)!.fileUrlNotFound);
      }
      return;
    }

    if (_isOpeningFile.value) return;
    _isOpeningFile.value = true;

    try {
      final tempDir = await getTemporaryDirectory();
      final resolvedFileName = fileName ?? Uri.parse(url).pathSegments.last;
      final savePath = '${tempDir.path}/$resolvedFileName';
      final file = File(savePath);

      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(url, savePath);
      }

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && mounted) {
        errorFlushBar(
          context,
          AppLocalizations.of(context)!.fileOpenError(result.message),
        );
      }
    } catch (e) {
      debugPrint(' File error: $e');
      if (mounted) {
        errorFlushBar(context, AppLocalizations.of(context)!.fileDownloadError);
      }
    } finally {
      if (mounted) _isOpeningFile.value = false;
    }
  }

  String _localizedPeriodicity(String p) {
    switch (p.toLowerCase()) {
      case 'year':
        return 'Yillik';
      case 'quarter':
        return 'Choraklik';
      case 'month':
        return 'Oylik';
      case 'week':
        return 'Haftalik';
      case 'day':
        return 'Kunlik';
      default:
        return p.isNotEmpty ? p : 'Yillik';
    }
  }

  String _formatAccessPolicy(String policy) {
    if (policy.toLowerCase() == 'license') {
      return 'Litsenziya asosida — ariza orqali foydalanish';
    }
    return policy.isNotEmpty ? policy : 'Litsenziya asosida';
  }

  void _openApplication(BuildContext context) {
    technicalWorkFlushBar(context, 'Tez orada');
    // openMiniAppSheetFamily(
    //   context,
    //   child: const AddDataRequestPage(),
    //   enableDrag: false,
    //   showHandler: false,
    // );
  }

  @override
  void initState() {
    super.initState();
    context.read<ReportFilesBloc>().add(
      ReportFilesEvent(params: ReportFilesParams(reportId: widget.item.id)),
    );
    context.read<ReportVariablesBloc>().add(
      ReportVariablesEvent(
        params: ReportVariablesParams(reportId: widget.item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final collectionMethodName =
        widget.item.collectionMethod?.localizedTitle(localeCode) ??
        'Tanlanma kuzatuv';
    final analysisUnitName =
        widget.item.analysisUnit?.localizedTitle(localeCode) ?? 'Uy xo‘jaligi';

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _openApplication(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: Text(
              'Ariza qoldirish',
              style: AppTextStyles.source.semiBold(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          //! Header
          const SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: "Hisobot ma'lumotlari"),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          //! Title & Subtitle + Top Action Button
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.name,
                    style: AppTextStyles.source.semiBold(
                      fontSize: 18,
                      color: AppColors.greyScale.grey900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          //! All 6 Cards Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! Card 1: To'plam identifikatsiyasi
                  _buildSectionCard(
                    title: 'To\'plam identifikatsiyasi',
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGridField(
                              label: 'Yagona ID',
                              value: widget.item.uniqueId,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGridField(
                              label: 'Davriylik',
                              value: _localizedPeriodicity(
                                widget.item.periodicity,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildGridField(
                        label: 'Ma\'lumot yig\'ish usuli',
                        value: collectionMethodName,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //! Card 2: Mazmuni va qamrovi
                  _buildSectionCard(
                    title: 'Mazmuni va qamrovi',
                    children: [
                      if (widget.item.annotation.isNotEmpty) ...[
                        _buildGridField(
                          label: 'Annotatsiya (Abstract)',
                          value: widget.item.annotation,
                          isDescription: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (widget.item.topics.isNotEmpty) ...[
                        Text(
                          'Mavzular',
                          style: AppTextStyles.source.regular(
                            fontSize: 12,
                            color: AppColors.greyScale.grey500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.item.topics
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyScale.grey100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    t,
                                    style: AppTextStyles.source.medium(
                                      fontSize: 12,
                                      color: AppColors.greyScale.grey700,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGridField(
                              label: 'Tahlil birligi',
                              value: analysisUnitName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGridField(
                              label: 'Hududiy qamrovi',
                              value: widget.item.formattedLocation(localeCode),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGridField(
                              label: 'Vaqt qamrovi (dan)',
                              value: _formatDate(widget.item.timeCoverageFrom),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGridField(
                              label: 'Vaqt qamrovi (gacha)',
                              value: _formatDate(widget.item.timeCoverageTo),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //! Card 3: Metodologiya
                  _buildSectionCard(
                    title: 'Metodologiya',
                    children: [
                      _buildGridField(
                        label: 'Tanlanma tanlab olish usuli',
                        value:
                            widget.item.samplingMethod ??
                            'Oddiy tasodifiy tanlash (SRS); bosh to‘plamdagi har bir birlik teng va mustaqil tanlanish imkoniyatiga ega',
                      ),
                      const SizedBox(height: 16),
                      _buildGridField(
                        label: 'Kuzatuv yozuvlari soni',
                        value: _formatCoverage(widget.item.coverage),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildGridField(
                              label: 'Ma\'lumot davri (dan)',
                              value: _formatDate(widget.item.dataPeriodFrom),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGridField(
                              label: 'Ma\'lumot davri (gacha)',
                              value: _formatDate(widget.item.dataPeriodTo),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //! Card 4: O'zgaruvchilar lug'ati
                  _buildSectionCard(
                    title: 'O\'zgaruvchilar lug\'ati',
                    children: [_buildVariablesTable()],
                  ),

                  const SizedBox(height: 16),

                  //! Card 5: Ma'lumot fayllari
                  _buildSectionCard(
                    title: 'Ma\'lumot fayllari',
                    children: [_buildDataFileTile(context)],
                  ),

                  const SizedBox(height: 16),

                  //! Card 6: Kirish va huquqiy shartlar
                  _buildSectionCard(
                    title: 'Kirish va huquqiy shartlar',
                    children: [
                      _buildGridField(
                        label: 'Kirish siyosati',
                        value: _formatAccessPolicy(widget.item.accessPolicy),
                      ),
                      const SizedBox(height: 16),
                      _buildGridField(
                        label: 'Ma\'lumot egasi',
                        value:
                            widget.item.dataOwner ??
                            'Aholi turmush darajasi statistikasi va kambag‘allikni baholash boshqarmasi, O‘zbekiston Respublikasi Milliy statistika qo‘mitasi',
                      ),
                      const SizedBox(height: 16),
                      _buildGridField(
                        label: 'Kontakt',
                        value: widget.item.contact ?? '+998 71 203 80 00',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! Section Card Container
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyScale.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.source.semiBold(
              fontSize: 16,
              color: AppColors.greyScale.grey900,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  //! Single Key-Value field
  Widget _buildGridField({
    required String label,
    required String value,
    bool isDescription = false,
  }) {
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
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '—',
          style: isDescription
              ? AppTextStyles.source.regular(
                  fontSize: 13.5,
                  color: AppColors.greyScale.grey800,
                )
              : AppTextStyles.source.semiBold(
                  fontSize: 14,
                  color: AppColors.greyScale.grey900,
                ),
        ),
      ],
    );
  }

  //! Card 4: Variables Dictionary Table Widget
  Widget _buildVariablesTable() {
    return BlocBuilder<ReportVariablesBloc, ReportVariablesState>(
      builder: (context, state) {
        if (state is ReportVariablesLoaded) {
          final variables = state.listEntity;

          if (variables.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyScale.grey200),
              ),
              child: Row(
                children: [
                  Icon(
                    IconlyLight.paper,
                    size: 20,
                    color: AppColors.greyScale.grey400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'O‘zgaruvchilar lug‘ati mavjud emas',
                      style: AppTextStyles.source.regular(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Column(
              children: [
                //! Table Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Nomi',
                          style: AppTextStyles.source.semiBold(
                            fontSize: 13,
                            color: AppColors.greyScale.grey700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qiymati',
                          style: AppTextStyles.source.semiBold(
                            fontSize: 13,
                            color: AppColors.greyScale.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //! Table Body Rows
                ...List.generate(variables.length, (index) {
                  final row = variables[index];
                  final isLast = index == variables.length - 1;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: AppColors.greyScale.grey200,
                                width: 0.8,
                              ),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            row.label,
                            style: AppTextStyles.source.medium(
                              fontSize: 13,
                              color: AppColors.greyScale.grey900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            row.value,
                            style: AppTextStyles.source.regular(
                              fontSize: 12.5,
                              color: AppColors.greyScale.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }

        if (state is ReportVariablesError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Row(
              children: [
                Icon(
                  IconlyLight.info_square,
                  size: 20,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'O‘zgaruvchilar lug‘atini yuklashda xatolik yuz berdi',
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        //! Loading state (Skeletonizer)
        return Skeletonizer(
          enabled: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Nomi',
                          style: AppTextStyles.source.semiBold(
                            fontSize: 13,
                            color: AppColors.greyScale.grey700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Qiymati',
                          style: AppTextStyles.source.semiBold(
                            fontSize: 13,
                            color: AppColors.greyScale.grey700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(4, (index) {
                  final isLast = index == 3;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: AppColors.greyScale.grey200,
                                width: 0.8,
                              ),
                            ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            'UX_TR',
                            style: AppTextStyles.source.medium(
                              fontSize: 13,
                              color: AppColors.greyScale.grey900,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Uy xo‘jaligi tartib raqami (id)si',
                            style: AppTextStyles.source.regular(
                              fontSize: 12.5,
                              color: AppColors.greyScale.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  //! Card 5: File item tile
  Widget _buildDataFileTile(BuildContext context) {
    return BlocBuilder<ReportFilesBloc, ReportFilesState>(
      builder: (context, state) {
        if (state is ReportFilesLoaded) {
          final data = state.listEntity;

          if (data.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.greyScale.grey200),
              ),
              child: Row(
                children: [
                  Icon(
                    IconlyLight.document,
                    size: 20,
                    color: AppColors.greyScale.grey400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Fayllar mavjud emas',
                      style: AppTextStyles.source.regular(
                        fontSize: 13,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          //! Data
          return Column(
            children: List.generate(data.length, (index) {
              final item = data[index];
              return Container(
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.only(
                  bottom: index == data.length - 1 ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyScale.grey200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.redBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf,
                        color: AppColors.redFailedTaskCard,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.source.semiBold(
                              fontSize: 14,
                              color: AppColors.greyScale.grey900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatFileSize(item.fileSize),
                            style: AppTextStyles.source.regular(
                              fontSize: 12,
                              color: AppColors.greyScale.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _openFile(
                        "${ApiUrls.baseUrl}data-reports/${widget.item.id}/download-file/${item.id}/",
                        fileName: item.fileName,
                      ),
                      icon: ValueListenableBuilder<bool>(
                        valueListenable: _isOpeningFile,
                        builder: (context, isLoading, _) {
                          if (isLoading) {
                            return const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }
                          return const Icon(
                            IconlyLight.download,
                            color: AppColors.primaryColor,
                            size: 22,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }

        if (state is ReportFilesError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Row(
              children: [
                Icon(
                  IconlyLight.info_square,
                  size: 20,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Fayllarni yuklashda xatolik yuz berdi',
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        //! Loading state (Skeletonizer)
        return Skeletonizer(
          enabled: true,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyScale.grey200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf,
                    color: AppColors.redFailedTaskCard,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'fileName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.source.semiBold(
                          fontSize: 14,
                          color: AppColors.greyScale.grey900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'fileSizeText',
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.greyScale.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    IconlyLight.download,
                    color: AppColors.primaryColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
