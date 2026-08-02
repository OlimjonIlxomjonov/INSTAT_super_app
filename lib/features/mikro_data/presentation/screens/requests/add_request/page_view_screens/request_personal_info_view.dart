import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class RequestPersonalInfoView extends StatefulWidget {
  const RequestPersonalInfoView({super.key});

  @override
  State<RequestPersonalInfoView> createState() =>
      _RequestPersonalInfoViewState();
}

class _RequestPersonalInfoViewState extends State<RequestPersonalInfoView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();

  /// IntlPhoneField controller emas, initialValue orqali tiklanadi —
  /// PageView bosqichdan chiqilganda widget'ni tashlab yuboradi.
  String? _initialPhone;

  @override
  void initState() {
    super.initState();
    final state = context.read<AddDataRequestBloc>().state;
    _fullNameController.text = state.fullName;
    _emailController.text = state.email;
    _companyController.text = state.companyName;
    _initialPhone = state.phoneNumber.isEmpty ? null : state.phoneNumber;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _update(UpdateDataRequestFieldEvent event) {
    context.read<AddDataRequestBloc>().add(event);
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
            AuthTextFieldWg(
              title: localization.requestFullNameLabel,
              label: 'F.I.O ni kiriting',
              controller: _fullNameController,
              onChanged: (value) =>
                  _update(UpdateDataRequestFieldEvent(fullName: value)),
            ),
            const SizedBox(height: 14),

            AuthTextFieldWg(
              title: localization.emailLabel,
              label: localization.requestEmailHint,
              controller: _emailController,
              onChanged: (value) =>
                  _update(UpdateDataRequestFieldEvent(email: value)),
            ),
            const SizedBox(height: 14),

            /// TELEFON — article'dagi bilan bir xil formatlangan maydon
            Text(localization.phoneNumberLabel, style: CustomTextStyles.h3half),
            const SizedBox(height: 8),
            IntlPhoneField(
              pickerDialogStyle: PickerDialogStyle(
                backgroundColor: Colors.white,
              ),
              initialValue: _initialPhone,
              showCountryFlag: false,
              flagsButtonPadding: const EdgeInsets.only(left: 8.0),
              decoration: InputDecoration(
                hintText: '90 123 45 67',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppColors.greyScale.grey300,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.0,
                  ),
                ),
              ),
              initialCountryCode: 'UZ',
              showDropdownIcon: true,
              dropdownIcon: const Icon(IconlyLight.call),
              onChanged: (phone) => _update(
                UpdateDataRequestFieldEvent(phoneNumber: phone.completeNumber),
              ),
            ),
            const SizedBox(height: 14),

            AuthTextFieldWg(
              title: localization.requestCompanyLabel,
              label: "Ish joyingiz yoki o'quv muassasangiz nomi",
              controller: _companyController,
              onChanged: (value) =>
                  _update(UpdateDataRequestFieldEvent(companyName: value)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
