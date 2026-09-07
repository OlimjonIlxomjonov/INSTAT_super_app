import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/date_picker_sheet.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/picker_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_input_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_section_card_wg.dart';

class RequestEnvironmentView extends StatefulWidget {
  const RequestEnvironmentView({super.key});

  @override
  State<RequestEnvironmentView> createState() => _RequestEnvironmentViewState();
}

class _RequestEnvironmentViewState extends State<RequestEnvironmentView> {
  final _expectationController = TextEditingController();
  final _planController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AddDataRequestBloc>().state;
    _expectationController.text = state.expectation;
    _planController.text = state.plan;
  }

  @override
  void dispose() {
    _expectationController.dispose();
    _planController.dispose();
    super.dispose();
  }

  void _update(UpdateDataRequestFieldEvent event) {
    context.read<AddDataRequestBloc>().add(event);
  }

  Future<void> _pickEntryDate({required bool isFrom}) async {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();
    final state = bloc.state;

    final picked = await showDatePickerSheet(
      context,
      title: localization.requestEntryPeriodLabel,
      initialDate: isFrom ? state.entryDateFrom : state.entryDateTo,
    );
    if (picked == null) return;

    bloc.add(
      isFrom
          ? UpdateDataRequestFieldEvent(entryDateFrom: picked)
          : UpdateDataRequestFieldEvent(entryDateTo: picked),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// XAVFSIZLIK, MUHIT VA MUDDAT
            BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
              buildWhen: (prev, curr) =>
                  prev.processingEnvironmentName !=
                      curr.processingEnvironmentName ||
                  prev.entryDateFrom != curr.entryDateFrom ||
                  prev.entryDateTo != curr.entryDateTo,
              builder: (context, state) {
                return RequestSectionCardWg(
                  title: localization.requestStepSecurityEnv,
                  children: [
                    // Muhitlar endpointi kelgach ulanadi
                    RequestFieldWg(
                      label: localization.requestProcessingEnvLabel,
                      child: PickerFieldWg(
                        hintText: localization.requestProcessingEnvHint,
                        value: state.processingEnvironmentName.isEmpty
                            ? null
                            : state.processingEnvironmentName,
                        onTap: () => technicalWorkFlushBar(
                          context,
                          localization.requestProcessingEnvSoon,
                        ),
                      ),
                    ),
                    RequestFieldWg(
                      label: localization.requestEntryPeriodLabel,
                      child: Row(
                        children: [
                          Expanded(
                            child: PickerFieldWg(
                              hintText: localization.requestDateFromHint,
                              value: formatRequestDate(state.entryDateFrom),
                              leadingIcon: IconlyLight.calendar,
                              trailingIcon: Icons.chevron_right,
                              onTap: () => _pickEntryDate(isFrom: true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PickerFieldWg(
                              hintText: localization.requestDateToHint,
                              value: formatRequestDate(state.entryDateTo),
                              leadingIcon: IconlyLight.calendar,
                              trailingIcon: Icons.chevron_right,
                              onTap: () => _pickEntryDate(isFrom: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            /// NATIJALAR VA YAKUN
            RequestSectionCardWg(
              title: localization.requestResultsSectionTitle,
              children: [
                RequestFieldWg(
                  label: localization.requestExpectationLabel,
                  child: RequestInputWg(
                    controller: _expectationController,
                    hintText: localization.requestExpectationHint,
                    minLines: 3,
                    onChanged: (value) => _update(
                      UpdateDataRequestFieldEvent(expectation: value),
                    ),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestPlanLabel,
                  child: RequestInputWg(
                    controller: _planController,
                    hintText: localization.requestPlanHint,
                    minLines: 3,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(plan: value)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
