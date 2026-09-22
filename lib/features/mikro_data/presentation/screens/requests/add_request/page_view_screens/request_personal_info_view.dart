import 'package:flutter/material.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_field.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_form_field_wg.dart';
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
import 'package:my_template/core/utils/general_widgets/date_picker_sheet/date_picker_sheet.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_picker_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/report_picker_sheet.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_input_wg.dart';
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
            BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
              buildWhen: (prev, curr) => prev.fieldErrors != curr.fieldErrors,
              builder: (context, state) {
                final errors = state.fieldErrors;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RequestSectionCardWg(
                      title: localization.requestPersonalInfoTitle,
                      children: [
                        AppFormFieldWg(
                          label: localization.requestOrganizationLabel,
                          errorText: errors[RequestField.companyName],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _companyController,
                            hasError: errors.containsKey(
                              RequestField.companyName,
                            ),
                            hintText: localization.requestOrganizationHint,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(companyName: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestResearcherLabel,
                          errorText: errors[RequestField.fullName],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _fullNameController,
                            hasError: errors.containsKey(RequestField.fullName),
                            hintText: localization.requestResearcherHint,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(fullName: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestContactLabel,
                          errorText: errors[RequestField.phoneNumber],
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
                                  color:
                                      errors.containsKey(
                                        RequestField.phoneNumber,
                                      )
                                      ? AppColors.redFailedTaskCard
                                      : AppColors.greyScale.grey300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      errors.containsKey(
                                        RequestField.phoneNumber,
                                      )
                                      ? AppColors.redFailedTaskCard
                                      : AppColors.primaryColor,
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
                        AppFormFieldWg(
                          label: localization.emailLabel,
                          errorText: errors[RequestField.email],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _emailController,
                            hasError: errors.containsKey(RequestField.email),
                            hintText: localization.requestEmailHint,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(email: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestTeamMembersLabel,
                          child: AppInputWg(
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
                        AppFormFieldWg(
                          label: localization.requestProjectNameLabel,
                          errorText: errors[RequestField.projectName],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _projectNameController,
                            hasError: errors.containsKey(
                              RequestField.projectName,
                            ),
                            hintText: localization.requestProjectNameHint,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(projectName: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestProjectAimLabel,
                          errorText: errors[RequestField.projectAim],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _projectAimController,
                            hasError: errors.containsKey(
                              RequestField.projectAim,
                            ),
                            hintText: localization.requestProjectAimHint,
                            minLines: 3,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(projectAim: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestBenefitLabel,
                          errorText: errors[RequestField.benefit],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _benefitController,
                            hasError: errors.containsKey(RequestField.benefit),
                            hintText: localization.requestBenefitHint,
                            minLines: 3,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(benefit: value),
                            ),
                          ),
                        ),
                        AppFormFieldWg(
                          label: localization.requestAimToUseLabel,
                          errorText: errors[RequestField.aimToUse],
                          isRequired: true,
                          child: AppInputWg(
                            controller: _aimToUseController,
                            hasError: errors.containsKey(RequestField.aimToUse),
                            hintText: localization.requestAimToUseHint,
                            minLines: 3,
                            onChanged: (value) => _update(
                              UpdateDataRequestFieldEvent(aimToUse: value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            /// SO'RALADIGAN MA'LUMOT
            BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
              buildWhen: (prev, curr) =>
                  prev.dataReport != curr.dataReport ||
                  prev.dateFrom != curr.dateFrom ||
                  prev.dateTo != curr.dateTo ||
                  prev.fieldErrors != curr.fieldErrors,
              builder: (context, state) {
                final errors = state.fieldErrors;
                return RequestSectionCardWg(
                  title: localization.requestRequestedDataTitle,
                  children: [
                    AppFormFieldWg(
                      label: localization.requestDataReportLabel,
                      errorText: errors[RequestField.dataReport],
                      isRequired: true,
                      child: AppPickerFieldWg(
                        hintText: localization.requestDataReportHint,
                        hasError: errors.containsKey(RequestField.dataReport),
                        value: state.dataReport?.name,
                        onTap: _pickReport,
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.requestPeriodFromLabel,
                      errorText: errors[RequestField.dateFrom],
                      isRequired: true,
                      child: AppPickerFieldWg(
                        hintText: localization.requestSelectDateHint,
                        hasError: errors.containsKey(RequestField.dateFrom),
                        value: formatRequestDate(state.dateFrom),
                        leadingIcon: IconlyLight.calendar,
                        trailingIcon: Icons.chevron_right,
                        onTap: () => _pickDate(isFrom: true),
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.requestPeriodToLabel,
                      errorText: errors[RequestField.dateTo],
                      isRequired: true,
                      child: AppPickerFieldWg(
                        hintText: localization.requestSelectDateHint,
                        hasError: errors.containsKey(RequestField.dateTo),
                        value: formatRequestDate(state.dateTo),
                        leadingIcon: IconlyLight.calendar,
                        trailingIcon: Icons.chevron_right,
                        onTap: () => _pickDate(isFrom: false),
                      ),
                    ),

                    // Saytdagi "Tashqi manbalar" toggle'i backendda alohida
                    // maydon emas — ikkala izoh ham majburiy matn.
                    AppFormFieldWg(
                      label: localization.requestWhyNotEnoughLabel,
                      errorText: errors[RequestField.whyNotEnough],
                      isRequired: true,
                      child: AppInputWg(
                        controller: _whyNotEnoughController,
                        hasError: errors.containsKey(RequestField.whyNotEnough),
                        hintText: localization.requestWhyNotEnoughHint,
                        minLines: 3,
                        onChanged: (value) => _update(
                          UpdateDataRequestFieldEvent(whyNotEnough: value),
                        ),
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.requestNotEnoughCommentLabel,
                      errorText: errors[RequestField.notEnoughComment],
                      isRequired: true,
                      child: AppInputWg(
                        controller: _notEnoughCommentController,
                        hasError: errors.containsKey(
                          RequestField.notEnoughComment,
                        ),
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
