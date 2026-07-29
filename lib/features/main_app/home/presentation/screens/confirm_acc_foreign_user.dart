import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/main_app/home/domain/entity/country/country_entity.dart';
import 'package:my_template/features/main_app/home/domain/usecase/get_countries_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/register_not_resident_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';

class ConfirmAccForeignUser extends StatefulWidget {
  const ConfirmAccForeignUser({super.key});

  @override
  State<ConfirmAccForeignUser> createState() => _ConfirmAccForeignUserState();
}

class _ConfirmAccForeignUserState extends State<ConfirmAccForeignUser> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  int? _selectedCountryIndex; // index into _countries
  bool _agreedToTerms = false;

  File? _documentFile;
  String? _documentFileName;
  int? _documentFileSize;
  bool _isPickingFile = false;

  List<CountryEntity> _countries = [];
  bool _isLoadingCountries = true;
  bool _countriesLoadFailed = false;

  bool _isSubmitting = false;
  String? _passportError;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    setState(() {
      _isLoadingCountries = true;
      _countriesLoadFailed = false;
    });
    try {
      final countries = await sl<GetCountriesUseCase>().call();
      if (!mounted) return;
      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingCountries = false;
        _countriesLoadFailed = true;
      });
    }
  }

  List<DropDownEntity> get _countryOptions {
    final localeCode = Localizations.localeOf(context).languageCode;
    return List.generate(
      _countries.length,
      (index) => DropDownEntity(
        id: index,
        name: _countries[index].displayName(localeCode),
        isActive: true,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _documentNumberController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _selectedCountryIndex != null &&
      _lastNameController.text.trim().isNotEmpty &&
      _firstNameController.text.trim().isNotEmpty &&
      _fatherNameController.text.trim().isNotEmpty &&
      _documentNumberController.text.trim().isNotEmpty &&
      _phoneNumberController.text.trim().isNotEmpty &&
      _documentFile != null &&
      _agreedToTerms;

  Future<void> _pickDocumentPhoto() async {
    final localization = AppLocalizations.of(context)!;
    if (_isPickingFile) return;
    setState(() => _isPickingFile = true);
    try {
      final picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: {'jpg', 'jpeg', 'png', 'pdf'},
        allowMultiple: false,
        invalidExtensionMessage: localization.mainFileInvalidExtension,
        noFileChosenMessage: localization.noFileChosen,
        pickErrorMessage: localization.filePickError,
        useImagePickerFallback: true,
      );
      if (picked.isEmpty || !mounted) return;

      final item = picked.first;
      final size = await item.file.length();
      if (!mounted) return;
      setState(() {
        _documentFile = item.file;
        _documentFileName = item.name;
        _documentFileSize = size;
      });
    } on ArticleFilePickerException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  Future<void> _submit() async {
    if (!_isFormValid || _isSubmitting || _selectedCountryIndex == null) {
      return;
    }
    final localization = AppLocalizations.of(context)!;

    setState(() {
      _isSubmitting = true;
      _passportError = null;
    });

    try {
      final country = _countries[_selectedCountryIndex!];
      await sl<RegisterNotResidentUseCase>().call(
        RegisterNotResidentParams(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          middleName: _fatherNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          passportNumber: _documentNumberController.text.trim(),
          countryId: country.id,
          verifiedImage: _documentFile!,
        ),
      );

      if (!mounted) return;
      successFlushBar(context, localization.notResidentSubmitSuccess);
      context.read<UserMeBloc>().add(UserMeEvent());
    } on ValidationException catch (e) {
      if (!mounted) return;
      setState(() {
        _passportError =
            e.firstErrorFor('pport_no') ??
            localization.somethingWentWrongTryAgain;
      });
    } catch (_) {
      if (!mounted) return;
      errorFlushBar(context, localization.somethingWentWrongTryAgain);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBarWg(myTitle: localization.accountConfirm),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    CustomDropDownMenuWg(
                      title: localization.countryLabel,
                      hintText: _isLoadingCountries
                          ? localization.loadingEllipsis
                          : (_countriesLoadFailed
                                ? localization.countriesLoadErrorHint
                                : localization.selectCountryHint),
                      leadingIcon: IconlyLight.location,
                      options: _countryOptions,
                      value: _selectedCountryIndex,
                      onChanged: (_isLoadingCountries || _countriesLoadFailed)
                          ? null
                          : (val) =>
                                setState(() => _selectedCountryIndex = val),
                    ),
                    if (_countriesLoadFailed)
                      GestureDetector(
                        onTap: _fetchCountries,
                        child: Text(
                          localization.retry,
                          style: AppTextStyles.source.medium(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    AuthTextFieldWg(
                      title: localization.lastNameLabel,
                      label: localization.enterLastNameHint,
                      controller: _lastNameController,
                      leadingIcon: IconlyLight.profile,
                      onChanged: (_) => setState(() {}),
                    ),
                    AuthTextFieldWg(
                      title: localization.firstNameLabel,
                      label: localization.enterFirstNameHint,
                      controller: _firstNameController,
                      leadingIcon: IconlyLight.profile,
                      onChanged: (_) => setState(() {}),
                    ),
                    AuthTextFieldWg(
                      title: localization.fatherNameLabel,
                      label: localization.enterFatherNameHint,
                      controller: _fatherNameController,
                      leadingIcon: IconlyLight.profile,
                      onChanged: (_) => setState(() {}),
                    ),
                    AuthTextFieldWg(
                      title: localization.documentNumberLabel,
                      label: localization.enterDocumentNumberHint,
                      controller: _documentNumberController,
                      leadingIcon: IconlyLight.document,
                      onChanged: (_) => setState(() => _passportError = null),
                    ),
                    if (_passportError != null)
                      Text(
                        _passportError!,
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.red,
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localization.phoneNumberLabel,
                          style: CustomTextStyles.h3half,
                        ),
                        const SizedBox(height: 8),
                        IntlPhoneField(
                          pickerDialogStyle: PickerDialogStyle(
                            backgroundColor: Colors.white,
                          ),
                          controller: _phoneNumberController,
                          showCountryFlag: false,
                          flagsButtonPadding: const EdgeInsets.only(left: 8.0),
                          decoration: InputDecoration(
                            hintText: localization.enterPhoneNumberHint,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.greyScale.grey300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          initialCountryCode: 'UZ',
                          showDropdownIcon: true,
                          dropdownIcon: const Icon(IconlyLight.call),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                    Text(
                      localization.documentPhotoTitle,
                      style: CustomTextStyles.h3half,
                    ),
                    DottedContainerWg(
                      formatsHint: localization.documentPhotoFormatsHint,
                      onTap: _isPickingFile ? null : _pickDocumentPhoto,
                    ),
                    if (_isPickingFile) ...[
                      const SizedBox(height: 10),
                      const Center(child: CircularProgressIndicator.adaptive()),
                    ] else if (_documentFile != null) ...[
                      SelectedFileContainerWg(
                        fileName: _documentFileName,
                        fileSize: _documentFileSize != null
                            ? ArticleFilePickerHelper.formatFileSize(
                                _documentFileSize!,
                              )
                            : null,
                      ),
                    ],
                    const SizedBox(height: 10),
                    _AgreementCheckboxRow(
                      value: _agreedToTerms,
                      onChanged: (val) =>
                          setState(() => _agreedToTerms = val ?? false),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: (_isFormValid && !_isSubmitting) ? 1.0 : 0.5,
              child: CustomBottomNavContainerWg(
                buttonText: localization.confirm,
                isLoading: _isSubmitting,
                onTap: (_isFormValid && !_isSubmitting) ? _submit : () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgreementCheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AgreementCheckboxRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final linkStyle = AppTextStyles.source
        .regular(fontSize: 14, color: AppColors.primaryColor)
        .copyWith(decoration: TextDecoration.underline);
    final plainStyle = AppTextStyles.source.regular(
      fontSize: 14,
      color: AppColors.greyScale.grey800,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            checkColor: AppColors.primaryColor,
            activeColor: AppColors.white,
            side: BorderSide(width: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onChanged(!value),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: localization.agreementPrefixText),
                  TextSpan(
                    text: localization.userAgreementLinkText,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: open the user agreement (needs a URL/page).
                      },
                  ),
                  TextSpan(text: localization.agreementMiddleText),
                  TextSpan(
                    text: localization.additionalAgreementsLinkText,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: open additional agreements (needs a URL/page).
                      },
                  ),
                  TextSpan(text: localization.agreementSuffixText),
                ],
                style: plainStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
