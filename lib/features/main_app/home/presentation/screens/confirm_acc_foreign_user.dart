import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/countries.dart' as intl_countries;
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';

import '../../../../../core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'drawer/components/log_out_options_component.dart';

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

  int? _selectedCountryIndex;
  bool _agreedToTerms = false;

  File? _documentFile;
  String? _documentFileName;
  int? _documentFileSize;
  bool _isPickingFile = false;

  late final List<DropDownEntity> _countryOptions = List.generate(
    intl_countries.countries.length,
    (index) => DropDownEntity(
      id: index,
      name: intl_countries.countries[index].name,
      isActive: true,
      createdAt: DateTime.now(),
    ),
  );

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

  void _submit() {
    if (!_isFormValid) return;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //         width: 44,
            //         height: 44,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(color: AppColors.greyScale.grey200),
            //         ),
            //         child: Icon(
            //           IconlyLight.profile,
            //           color: AppColors.greyScale.grey600,
            //         ),
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               localization.foreignUserProfileTitle,
            //               style: CustomTextStyles.h2,
            //             ),
            //             const SizedBox(height: 4),
            //             Text(
            //               localization.foreignUserProfileSubtitle,
            //               style: AppTextStyles.source.regular(
            //                 fontSize: 14,
            //                 color: AppColors.greyScale.grey600,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    IconButton(
                      onPressed: () {
                        subBottomSheetOpener(
                          context,
                          child: const LogOutOptionsComponent(),
                          isExpanded: false,
                        );
                      },
                      icon: Icon(
                        IconlyLight.logout,
                        color: AppColors.redFailedTaskCard,
                      ),
                    ),
                    CustomDropDownMenuWg(
                      title: localization.countryLabel,
                      hintText: localization.selectCountryHint,
                      leadingIcon: IconlyLight.location,
                      options: _countryOptions,
                      value: _selectedCountryIndex,
                      onChanged: (val) =>
                          setState(() => _selectedCountryIndex = val),
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
                      onChanged: (_) => setState(() {}),
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
                    const SizedBox(height: 6),
                    Text(
                      localization.documentPhotoTitle,
                      style: CustomTextStyles.h3half,
                    ),
                    const SizedBox(height: 8),
                    DottedContainerWg(
                      formatsHint: localization.documentPhotoFormatsHint,
                      onTap: _isPickingFile ? null : _pickDocumentPhoto,
                    ),
                    if (_isPickingFile) ...[
                      const SizedBox(height: 15),
                      const Center(child: CircularProgressIndicator.adaptive()),
                    ] else if (_documentFile != null) ...[
                      const SizedBox(height: 15),
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
              opacity: _isFormValid ? 1.0 : 0.5,
              child: CustomBottomNavContainerWg(
                buttonText: localization.confirm,
                onTap: _isFormValid ? _submit : () {},
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
