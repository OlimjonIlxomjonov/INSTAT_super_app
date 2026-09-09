import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/file_opening_overlay/file_opening_overlay_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/widgets/detail_tabs/detail_tabs_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_request_processes/data_request_processes_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/page_view_screens/request_summary_view.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_file_opener.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_process_item_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_status_check_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_summary_body_wg.dart';

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

  Future<void> _openFile(String? url, {String? fileName}) async {
    if (_isOpeningFile.value) return;
    _isOpeningFile.value = true;
    try {
      await openRequestFile(context, url: url, fileName: fileName);
    } finally {
      if (mounted) _isOpeningFile.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final tabs = [
      DetailTabItem(
        label: localization.requestTabInfo,
        icon: FlutterRemix.file_list_2_line,
      ),
      DetailTabItem(
        label: localization.requestTabProcesses,
        icon: FlutterRemix.list_check_2,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SheetDragAreaWg(
                  child: CustomAppBarWg(
                    myTitle: localization.requestDetailPageTitle,
                  ),
                ),
              ),

              /// TABS
              SliverToBoxAdapter(
                child: DetailTabsWg(
                  tabs: tabs,
                  selectedIndex: _selectedTab,
                  onChanged: (index) => setState(() => _selectedTab = index),
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
                RequestSummaryBodyWg(
                  data: state.toSummaryData(),
                  trailing: RequestStatusCheckWg(status: widget.status),
                  onFileTap: () =>
                      _openFile(state.fileUrl, fileName: state.fileName),
                  onCompanyFileTap: () => _openFile(
                    state.companyFileUrl,
                    fileName: state.companyFileName,
                  ),
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
            const SizedBox(height: 4),
            Text(localization.requestExpertAnswer, style: CustomTextStyles.h2),
            const SizedBox(height: 16),
            if (comment.isNotEmpty) ...[
              Text(
                localization.requestNotEnoughCommentLabel,
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
                  onTap: () => _openFile(item.file, fileName: item.fileName),
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
