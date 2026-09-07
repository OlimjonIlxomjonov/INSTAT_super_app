import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_report_ref_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_state.dart';

Future<DataReportRefEntity?> showReportPickerSheet(
  BuildContext context, {
  required ReportsBloc reportsBloc,
  int? selectedId,
}) {
  return showModalBottomSheet<DataReportRefEntity>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: reportsBloc,
      child: _ReportPickerSheet(selectedId: selectedId),
    ),
  );
}

class _ReportPickerSheet extends StatefulWidget {
  const _ReportPickerSheet({this.selectedId});

  final int? selectedId;

  @override
  State<_ReportPickerSheet> createState() => _ReportPickerSheetState();
}

class _ReportPickerSheetState extends State<_ReportPickerSheet> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    final state = context.read<ReportsBloc>().state;
    if (state is! ReportsLoaded) {
      context.read<ReportsBloc>().add(ReportsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey300,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: AppPadding.horizontal20x(),
              child: Text(
                localization.requestSelectReportTitle,
                style: CustomTextStyles.h2,
              ),
            ),
            const SizedBox(height: 16),

            // Qidiruv
            Padding(
              padding: AppPadding.horizontal20x(),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                style: AppTextStyles.source.regular(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  hintText: localization.requestSearchHint,
                  hintStyle: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.greyScale.grey400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.greyScale.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state is ReportsLoading || state is ReportsInitial) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (state is! ReportsLoaded) {
                    return Center(
                      child: Text(
                        localization.genericError,
                        style: CustomTextStyles.h3half,
                      ),
                    );
                  }

                  final items = state.response.data
                      .where(
                        (e) =>
                            e.name.toLowerCase().contains(_query.toLowerCase()),
                      )
                      .toList();

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        localization.nothingFound,
                        style: CustomTextStyles.h3half,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: AppPadding.horizontal20x(),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = item.id == widget.selectedId;
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(
                          DataReportRefEntity(id: item.id, name: item.name),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.greyScale.grey200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: AppTextStyles.source.medium(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
