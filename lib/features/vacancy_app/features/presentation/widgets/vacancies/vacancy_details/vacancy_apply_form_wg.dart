import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';
import 'package:my_template/core/utils/general_widgets/date_picker_sheet/date_picker_sheet.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_form_field_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_input_wg.dart';
import 'package:my_template/core/utils/general_widgets/form_fields/app_picker_field_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/features/vacancy_app/features/presentation/bloc/apply/vacancy_apply_cubit.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_formatters.dart';

const Set<String> _allowedExtensions = {'pdf', 'docx'};
const int _maxFileSizeBytes = 50 * 1024 * 1024;

final _emailRegExp = RegExp(r'^[\w.!#$%&*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$');

enum _ApplyField { firstName, lastName, birthDate, phone, email, files }

class VacancyApplyFormWg extends StatelessWidget {
  final int vacancyId;
  final VoidCallback? onSubmitted;

  const VacancyApplyFormWg({
    super.key,
    required this.vacancyId,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VacancyApplyCubit>(),
      child: _VacancyApplyFormView(
        vacancyId: vacancyId,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _VacancyApplyFormView extends StatefulWidget {
  final int vacancyId;
  final VoidCallback? onSubmitted;

  const _VacancyApplyFormView({required this.vacancyId, this.onSubmitted});

  @override
  State<_VacancyApplyFormView> createState() => _VacancyApplyFormViewState();
}

class _VacancyApplyFormViewState extends State<_VacancyApplyFormView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime? _birthDate;
  final List<({File file, String name})> _files = [];
  Map<_ApplyField, String> _errors = const {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _clearError(_ApplyField field) {
    if (!_errors.containsKey(field)) return;
    setState(() => _errors = Map.of(_errors)..remove(field));
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePickerSheet(
      context,
      title: AppLocalizations.of(context)!.birthDateLabel,
      initialDate: _birthDate ?? DateTime(2001),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      _birthDate = picked;
      _errors = Map.of(_errors)..remove(_ApplyField.birthDate);
    });
  }

  Future<void> _pickFiles() async {
    final l = AppLocalizations.of(context)!;
    List<({File file, String name})> picked;
    try {
      picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: _allowedExtensions,
        allowMultiple: true,
        invalidExtensionMessage: l.vacancyFileInvalidExtension,
        noFileChosenMessage: l.noFileChosen,
        pickErrorMessage: l.filePickError,
      );
    } on ArticleFilePickerException catch (e) {
      if (mounted) errorFlushBar(context, e.message);
      return;
    }
    if (picked.isEmpty) return;

    for (final item in picked) {
      if (await item.file.length() > _maxFileSizeBytes) {
        if (mounted) errorFlushBar(context, l.fileSizeLimitError);
        return;
      }
    }
    if (!mounted) return;
    setState(() {
      _files.addAll(picked);
      _errors = Map.of(_errors)..remove(_ApplyField.files);
    });
  }

  //! Tekshiruv
  Map<_ApplyField, String> _validate(AppLocalizations l) {
    final errors = <_ApplyField, String>{};

    if (_firstNameController.text.trim().isEmpty) {
      errors[_ApplyField.firstName] = l.fieldRequired;
    }
    if (_lastNameController.text.trim().isEmpty) {
      errors[_ApplyField.lastName] = l.fieldRequired;
    }
    if (_birthDate == null) errors[_ApplyField.birthDate] = l.fieldRequired;

    final phone = _phoneController.text.replaceAll(RegExp(r'[^0-9+]'), '');
    if (phone.isEmpty) {
      errors[_ApplyField.phone] = l.fieldRequired;
    } else if (phone.replaceAll('+', '').length < 9) {
      errors[_ApplyField.phone] = l.invalidPhoneNumber;
    }

    final email = _emailController.text.trim();
    if (email.isEmpty) {
      errors[_ApplyField.email] = l.fieldRequired;
    } else if (!_emailRegExp.hasMatch(email)) {
      errors[_ApplyField.email] = l.invalidEmail;
    }

    if (_files.isEmpty) errors[_ApplyField.files] = l.filesRequired;
    return errors;
  }

  void _submit() {
    final l = AppLocalizations.of(context)!;
    FocusManager.instance.primaryFocus?.unfocus();

    final errors = _validate(l);
    setState(() => _errors = errors);
    if (errors.isNotEmpty) {
      errorFlushBar(context, errors.values.first);
      return;
    }

    context.read<VacancyApplyCubit>().submit(
      ApplyVacancyParams(
        vacancyId: widget.vacancyId,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _birthDate!,
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        files: [for (final f in _files) f.file],
      ),
      onSuccess: () {
        if (!mounted) return;
        showSuccessDialog(
          context,
          title: l.applicationSentTitle,
          description: l.applicationSentDescription,
          onDismiss: () {
            FamilyNavigation.familyClose(context);
            widget.onSubmitted?.call();
          },
        );
      },
      onError: (message) {
        if (mounted) errorFlushBar(context, message ?? l.sectionLoadError);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isSubmitting = context.watch<VacancyApplyCubit>().state;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        //! Bo'sh joyga bosish
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            //! Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Icon(
                        FlutterRemix.chat_1_line,
                        size: 20,
                        color: AppColors.greyScale.grey700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.submitApplication,
                            style: AppTextStyles.source.semiBold(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            localization.enterYourInfo,
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.greyScale.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //! Form
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFormFieldWg(
                      label: localization.lastNameLabel,
                      isRequired: true,
                      errorText: _errors[_ApplyField.lastName],
                      child: AppInputWg(
                        controller: _lastNameController,
                        hintText: 'Karimov',
                        hasError: _errors.containsKey(_ApplyField.lastName),
                        onChanged: (_) => _clearError(_ApplyField.lastName),
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.firstNameLabel,
                      isRequired: true,
                      errorText: _errors[_ApplyField.firstName],
                      child: AppInputWg(
                        controller: _firstNameController,
                        hintText: 'Azizbek',
                        hasError: _errors.containsKey(_ApplyField.firstName),
                        onChanged: (_) => _clearError(_ApplyField.firstName),
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.birthDateLabel,
                      isRequired: true,
                      errorText: _errors[_ApplyField.birthDate],
                      child: AppPickerFieldWg(
                        hintText: '01.01.2001',
                        value: _birthDate == null
                            ? null
                            : formatVacancyDate(_birthDate),
                        trailingIcon: FlutterRemix.calendar_line,
                        hasError: _errors.containsKey(_ApplyField.birthDate),
                        onTap: _pickBirthDate,
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.phoneNumberLabel,
                      isRequired: true,
                      errorText: _errors[_ApplyField.phone],
                      child: AppInputWg(
                        controller: _phoneController,
                        hintText: '+998 (--) --- -- -',
                        keyboardType: TextInputType.phone,
                        hasError: _errors.containsKey(_ApplyField.phone),
                        onChanged: (_) => _clearError(_ApplyField.phone),
                      ),
                    ),
                    AppFormFieldWg(
                      label: localization.emailAddressLabel,
                      isRequired: true,
                      errorText: _errors[_ApplyField.email],
                      child: AppInputWg(
                        controller: _emailController,
                        hintText: 'azizbek.karimov@stat.uz',
                        keyboardType: TextInputType.emailAddress,
                        hasError: _errors.containsKey(_ApplyField.email),
                        onChanged: (_) => _clearError(_ApplyField.email),
                      ),
                    ),

                    //! Fayllar
                    const SizedBox(height: 4),
                    VacancySectionTitleWg(
                      title: '${localization.uploadFileTitle} *',
                    ),
                    const SizedBox(height: 12),
                    DottedContainerWg(
                      onTap: _pickFiles,
                      formatsHint: localization.vacancyFileFormatsHint,
                      hasError: _errors.containsKey(_ApplyField.files),
                    ),
                    if (_errors[_ApplyField.files] != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _errors[_ApplyField.files]!,
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.iconRed,
                        ),
                      ),
                    ],
                    for (final (index, item) in _files.indexed) ...[
                      const SizedBox(height: 12),
                      SelectedFileContainerWg(
                        fileName: item.name,
                        fileSize: formatFileSize(item.file.lengthSync()),
                        onRemove: () => setState(() => _files.removeAt(index)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: localization.submitApplication,
        isLoading: isSubmitting,
        onTap: _submit,
      ),
    );
  }
}
