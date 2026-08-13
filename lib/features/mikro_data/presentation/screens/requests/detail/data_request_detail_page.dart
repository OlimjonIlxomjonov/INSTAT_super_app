import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/file_opening_overlay/file_opening_overlay_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_request_processes/data_request_processes_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_categories/micro_data_categories_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/regions/regions_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_process_item_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_status_check_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_summary_body_wg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class DataRequestDetailPage extends StatelessWidget {
  const DataRequestDetailPage({
    super.key,
    required this.requestId,
    required this.status,
  });

  final int requestId;
  final MicroDataRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AddDataRequestBloc>()),
        BlocProvider(create: (_) => sl<MicroDataCategoriesBloc>()),
        BlocProvider(create: (_) => sl<RegionsBloc>()),
        BlocProvider(create: (_) => sl<DataRequestProcessesBloc>()),
      ],
      child: _DataRequestDetailView(requestId: requestId, status: status),
    );
  }
}

class _DataRequestDetailView extends StatefulWidget {
  const _DataRequestDetailView({required this.requestId, required this.status});

  final int requestId;
  final MicroDataRequestStatus status;

  @override
  State<_DataRequestDetailView> createState() => _DataRequestDetailViewState();
}

class _DataRequestDetailViewState extends State<_DataRequestDetailView> {
  int _selectedTab = 0;

  final ValueNotifier<bool> _isOpeningFile = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<MicroDataCategoriesBloc>().add(
      const MicroDataCategoriesEvent(),
    );
    context.read<RegionsBloc>().add(const RegionsEvent());
    context.read<AddDataRequestBloc>().add(
      LoadDataRequestForEditEvent(requestId: widget.requestId),
    );
    context.read<DataRequestProcessesBloc>().add(
      DataRequestProcessesEvent(requestId: widget.requestId),
    );
  }

  @override
  void dispose() {
    _isOpeningFile.dispose();
    super.dispose();
  }

  /// Kategoriya id va hudud kodlarini obyektlarga bog'laydi — ikkala
  /// ro'yxat ham kelgandagina ishlaydi.
  void _resolveReferences() {
    final categoriesState = context.read<MicroDataCategoriesBloc>().state;
    final regionsState = context.read<RegionsBloc>().state;
    if (categoriesState is! MicroDataCategoriesLoaded) return;
    if (regionsState is! RegionsLoaded) return;
    if (!context.read<AddDataRequestBloc>().state.hasPendingReferences) return;

    context.read<AddDataRequestBloc>().add(
      ResolveDataRequestReferencesEvent(
        categories: categoriesState.items,
        regions: regionsState.items,
      ),
    );
  }

  /// Article'dagi bilan bir xil: faylni vaqtinchalik papkaga yuklab, tizim
  /// ilovasida ochadi.
  Future<void> _openFile(String? url) async {
    final localization = AppLocalizations.of(context)!;
    if (url == null || url.isEmpty) {
      errorFlushBar(context, localization.fileUrlNotFound);
      return;
    }
    if (_isOpeningFile.value) return;
    _isOpeningFile.value = true;

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = Uri.parse(url).pathSegments.last;
      final savePath = '${tempDir.path}/$fileName';

      await Dio().download(url, savePath);

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && mounted) {
        errorFlushBar(context, localization.fileOpenError(result.message));
      }
    } catch (_) {
      if (mounted) errorFlushBar(context, localization.savingError);
    } finally {
      _isOpeningFile.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final tabs = [
      localization.requestTabInfo,
      localization.requestTabProcesses,
    ];

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<MicroDataCategoriesBloc, MicroDataCategoriesState>(
            listener: (_, _) => _resolveReferences(),
          ),
          BlocListener<RegionsBloc, RegionsState>(
            listener: (_, _) => _resolveReferences(),
          ),
          BlocListener<AddDataRequestBloc, AddDataRequestState>(
            listenWhen: (prev, curr) =>
                prev.hasPendingReferences != curr.hasPendingReferences,
            listener: (_, _) => _resolveReferences(),
          ),
        ],
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // SliverDefaultAppBarWg(
                //   myTitle: localization.requestDetailPageTitle,
                //   isFamily: true,
                // ),
                SliverToBoxAdapter(
                  child: SheetDragAreaWg(
                    child: CustomAppBarWg(
                      myTitle: localization.requestDetailPageTitle,
                    ),
                  ),
                ),

                /// TABS
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        return EduCategoriesWg(
                          categoryIcon: FlutterRemix.layout_grid_line,
                          categoryName: tabs[index],
                          isSelected: _selectedTab == index,
                          onTap: () => setState(() => _selectedTab = index),
                        );
                      }),
                    ),
                  ),
                ),

                if (_selectedTab == 0) _buildInfoTab(localization),
                if (_selectedTab == 1) _buildProcessesTab(localization),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),

            /// Fayl yuklanayotganda butun ekranni yopadigan overlay
            ValueListenableBuilder<bool>(
              valueListenable: _isOpeningFile,
              builder: (context, isOpening, _) {
                if (!isOpening) return const SizedBox.shrink();
                return const FileOpeningOverlayWg();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(AppLocalizations localization) {
    return BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
      builder: (context, state) {
        if (state.isLoadingInitialData) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }

        if (state.initialLoadError != null) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: AppEmptyState(title: localization.detailsLoadError),
            ),
          );
        }

        return SliverPadding(
          padding: AppPadding.horizontal20x(),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SANA + STATUS
                Row(
                  children: [
                    Icon(
                      IconlyLight.calendar,
                      color: AppColors.greyScale.grey600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatRequestDate(state.dateFrom),
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    const Spacer(),
                    RequestStatusCheckWg(status: widget.status),
                  ],
                ),
                const SizedBox(height: 8),

                /// ID
                Text(
                  '#${state.requestId ?? widget.requestId}',
                  style: AppTextStyles.source.regular(
                    fontSize: 16,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                const SizedBox(height: 16),

                /// ASOSIY MA'LUMOT — wizard'ning 3-bosqichi bilan bir xil
                RequestSummaryBodyWg(
                  data: DataRequestSummaryData(
                    fullName: state.fullName,
                    email: state.email,
                    phoneNumber: state.phoneNumber,
                    companyName: state.companyName,
                    category: state.category,
                    area: state.area,
                    dateFrom: state.dateFrom,
                    dateTo: state.dateTo,
                    description: state.description,
                    aim: state.aim,
                    hasFile: state.hasFile,
                    fileName: state.fileName,
                    fileSize: state.fileSize,
                  ),
                  onFileTap: () => _openFile(state.fileUrl),
                ),

                /// EKSPERT JAVOBI
                _buildExpertAnswer(localization),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpertAnswer(AppLocalizations localization) {
    return BlocBuilder<DataRequestProcessesBloc, DataRequestProcessesState>(
      builder: (context, state) {
        if (state is! DataRequestProcessesLoaded) {
          return const SizedBox.shrink();
        }
        final answers = state.withFiles;
        if (answers.isEmpty) return const SizedBox.shrink();

        final comment = answers.last.comment;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(localization.requestExpertAnswer, style: CustomTextStyles.h2),
            const SizedBox(height: 16),
            if (comment.isNotEmpty) ...[
              Text(
                localization.requestDescriptionSummaryLabel,
                style: CustomTextStyles.h3half,
              ),
              const SizedBox(height: 4),
              Text(
                comment,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey700,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(localization.requestDocuments, style: CustomTextStyles.h3half),
            const SizedBox(height: 8),
            ...answers.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SelectedFileContainerWg(
                  fileName: item.fileName,
                  fileSize: formatRequestFileSize(item.fileSize),
                  onTap: () => _openFile(item.file),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProcessesTab(AppLocalizations localization) {
    return BlocBuilder<DataRequestProcessesBloc, DataRequestProcessesState>(
      builder: (context, state) {
        if (state is DataRequestProcessesError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: AppEmptyState(title: localization.detailsLoadError),
            ),
          );
        }

        if (state is! DataRequestProcessesLoaded) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
          );
        }

        if (state.items.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: AppEmptyState(title: localization.requestNoProcesses),
            ),
          );
        }

        // Article'dagidek sikllar bo'yicha guruhlanadi.
        final grouped = <int, List<DataRequestProcessEntity>>{};
        for (final item in state.items) {
          grouped.putIfAbsent(item.cycle, () => []).add(item);
        }
        final cycles = grouped.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return SliverMainAxisGroup(
          slivers: cycles.expand((entry) {
            final items = entry.value;
            return [
              SliverPadding(
                padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    localization.cycleLabel(entry.key),
                    style: CustomTextStyles.h2,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: AppPadding.horizontal20x(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.greyScale.grey200),
                  ),
                  child: Column(
                    children: List.generate(
                      items.length,
                      (index) => RequestProcessItemWg(
                        item: items[index],
                        isLast: index == items.length - 1,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          }).toList(),
        );
      },
    );
  }
}
