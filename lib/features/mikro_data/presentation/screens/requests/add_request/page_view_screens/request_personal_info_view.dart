import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/date_picker_sheet.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/picker_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/report_picker_sheet.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_input_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_section_card_wg.dart';

class RequestPersonalInfoView extends StatefulWidget {
  const RequestPersonalInfoView({super.key});

  @override
  State<RequestPersonalInfoView> createState() =>
      _RequestPersonalInfoViewState();
}

class _RequestPersonalInfoViewState extends State<RequestPersonalInfoView> {
  final _companyController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _teamMembersController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _projectAimController = TextEditingController();
  final _benefitController = TextEditingController();
  final _aimToUseController = TextEditingController();
  final _whyNotEnoughController = TextEditingController();
  final _notEnoughCommentController = TextEditingController();

  /// IntlPhoneField controller emas, initialValue orqali tiklanadi.
  String? _initialPhone;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddDataRequestBloc>().state;
    _companyController.text = state.companyName;
    _fullNameController.text = state.fullName;
    _emailController.text = state.email;
    _teamMembersController.text = state.teamMembers;
    _projectNameController.text = state.projectName;
    _projectAimController.text = state.projectAim;
    _benefitController.text = state.benefit;
    _aimToUseController.text = state.aimToUse;
    _whyNotEnoughController.text = state.whyNotEnough;
    _notEnoughCommentController.text = state.notEnoughComment;

    // Web'da raqam bo'shliqlar bilan saqlanadi — IntlPhoneField ularni ham
    // uzunlikka sanaydi, shuning uchun tozalab beramiz.
    _initialPhone = _normalizePhone(state.phoneNumber);
    if (_initialPhone != null && _initialPhone != state.phoneNumber) {
      _update(UpdateDataRequestFieldEvent(phoneNumber: _initialPhone));
    }
  }

  static String? _normalizePhone(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    return cleaned.isEmpty ? null : cleaned;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _teamMembersController.dispose();
    _projectNameController.dispose();
    _projectAimController.dispose();
    _benefitController.dispose();
    _aimToUseController.dispose();
    _whyNotEnoughController.dispose();
    _notEnoughCommentController.dispose();
    super.dispose();
  }

  void _update(UpdateDataRequestFieldEvent event) {
    context.read<AddDataRequestBloc>().add(event);
  }

  Future<void> _pickReport() async {
    final bloc = context.read<AddDataRequestBloc>();
    final selected = await showReportPickerSheet(
      context,
      reportsBloc: context.read<ReportsBloc>(),
      selectedId: bloc.state.dataReport?.id,
    );
    if (selected == null) return;
    bloc.add(UpdateDataRequestFieldEvent(dataReport: selected));
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final localization = AppLocalizations.of(context)!;
    final bloc = context.read<AddDataRequestBloc>();
    final state = bloc.state;

    final picked = await showDatePickerSheet(
      context,
      title: isFrom
          ? localization.requestPeriodFromLabel
          : localization.requestPeriodToLabel,
      initialDate: isFrom ? state.dateFrom : state.dateTo,
    );
    if (picked == null) return;

    bloc.add(
      isFrom
          ? UpdateDataRequestFieldEvent(dateFrom: picked)
          : UpdateDataRequestFieldEvent(dateTo: picked),
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
            /// SHAXSIY MA'LUMOT
            RequestSectionCardWg(
              title: localization.requestPersonalInfoTitle,
              children: [
                RequestFieldWg(
                  label: localization.requestOrganizationLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _companyController,
                    hintText: localization.requestOrganizationHint,
                    onChanged: (value) => _update(
                      UpdateDataRequestFieldEvent(companyName: value),
                    ),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestResearcherLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _fullNameController,
                    hintText: localization.requestResearcherHint,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(fullName: value)),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestContactLabel,
                  isRequired: true,
                  child: IntlPhoneField(
                    pickerDialogStyle: PickerDialogStyle(
                      backgroundColor: AppColors.white,
                    ),
                    initialValue: _initialPhone,
                    showCountryFlag: false,
                    flagsButtonPadding: const EdgeInsets.only(left: 8),
                    decoration: InputDecoration(
                      hintText: '90 123 45 67',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.greyScale.grey300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    initialCountryCode: 'UZ',
                    showDropdownIcon: true,
                    dropdownIcon: const Icon(IconlyLight.call),
                    onChanged: (phone) => _update(
                      UpdateDataRequestFieldEvent(
                        phoneNumber: phone.completeNumber,
                      ),
                    ),
                  ),
                ),
                RequestFieldWg(
                  label: localization.emailLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _emailController,
                    hintText: localization.requestEmailHint,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(email: value)),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestTeamMembersLabel,
                  child: RequestInputWg(
                    controller: _teamMembersController,
                    hintText: localization.requestTeamMembersHint,
                    minLines: 3,
                    onChanged: (value) => _update(
                      UpdateDataRequestFieldEvent(teamMembers: value),
                    ),
                  ),
                ),
              ],
            ),

            /// TADQIQOT LOYIHASI
            RequestSectionCardWg(
              title: localization.requestProjectSectionTitle,
              children: [
                RequestFieldWg(
                  label: localization.requestProjectNameLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _projectNameController,
                    hintText: localization.requestProjectNameHint,
                    onChanged: (value) => _update(
                      UpdateDataRequestFieldEvent(projectName: value),
                    ),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestProjectAimLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _projectAimController,
                    hintText: localization.requestProjectAimHint,
                    minLines: 3,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(projectAim: value)),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestBenefitLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _benefitController,
                    hintText: localization.requestBenefitHint,
                    minLines: 3,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(benefit: value)),
                  ),
                ),
                RequestFieldWg(
                  label: localization.requestAimToUseLabel,
                  isRequired: true,
                  child: RequestInputWg(
                    controller: _aimToUseController,
                    hintText: localization.requestAimToUseHint,
                    minLines: 3,
                    onChanged: (value) =>
                        _update(UpdateDataRequestFieldEvent(aimToUse: value)),
                  ),
                ),
              ],
            ),

            /// SO'RALADIGAN MA'LUMOT
            BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
              buildWhen: (prev, curr) =>
                  prev.dataReport != curr.dataReport ||
                  prev.dateFrom != curr.dateFrom ||
                  prev.dateTo != curr.dateTo,
              builder: (context, state) {
                return RequestSectionCardWg(
                  title: localization.requestRequestedDataTitle,
                  children: [
                    RequestFieldWg(
                      label: localization.requestDataReportLabel,
                      isRequired: true,
                      child: PickerFieldWg(
                        hintText: localization.requestDataReportHint,
                        value: state.dataReport?.name,
                        onTap: _pickReport,
                      ),
                    ),
                    RequestFieldWg(
                      label: localization.requestPeriodFromLabel,
                      isRequired: true,
                      child: PickerFieldWg(
                        hintText: localization.requestSelectDateHint,
                        value: formatRequestDate(state.dateFrom),
                        leadingIcon: IconlyLight.calendar,
                        trailingIcon: Icons.chevron_right,
                        onTap: () => _pickDate(isFrom: true),
                      ),
                    ),
                    RequestFieldWg(
                      label: localization.requestPeriodToLabel,
                      isRequired: true,
                      child: PickerFieldWg(
                        hintText: localization.requestSelectDateHint,
                        value: formatRequestDate(state.dateTo),
                        leadingIcon: IconlyLight.calendar,
                        trailingIcon: Icons.chevron_right,
                        onTap: () => _pickDate(isFrom: false),
                      ),
                    ),

                    // Saytdagi "Tashqi manbalar" toggle'i backendda alohida
                    // maydon emas — ikkala izoh ham majburiy matn.
                    RequestFieldWg(
                      label: localization.requestWhyNotEnoughLabel,
                      isRequired: true,
                      child: RequestInputWg(
                        controller: _whyNotEnoughController,
                        hintText: localization.requestWhyNotEnoughHint,
                        minLines: 3,
                        onChanged: (value) => _update(
                          UpdateDataRequestFieldEvent(whyNotEnough: value),
                        ),
                      ),
                    ),
                    RequestFieldWg(
                      label: localization.requestNotEnoughCommentLabel,
                      isRequired: true,
                      child: RequestInputWg(
                        controller: _notEnoughCommentController,
                        hintText: localization.requestNotEnoughCommentHint,
                        minLines: 3,
                        onChanged: (value) => _update(
                          UpdateDataRequestFieldEvent(notEnoughComment: value),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
