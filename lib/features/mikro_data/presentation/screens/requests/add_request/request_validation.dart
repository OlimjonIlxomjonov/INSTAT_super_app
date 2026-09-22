import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_field.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';

final _emailRegExp = RegExp(r'^[\w.!#$%&*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$');

Map<RequestField, String> validateDataRequest(
  AddDataRequestState state,
  AppLocalizations localization,
) {
  final errors = <RequestField, String>{};

  void requireText(RequestField field, String value) {
    if (value.trim().isEmpty) errors[field] = localization.fieldRequired;
  }

  requireText(RequestField.companyName, state.companyName);
  requireText(RequestField.fullName, state.fullName);
  requireText(RequestField.projectName, state.projectName);
  requireText(RequestField.projectAim, state.projectAim);
  requireText(RequestField.benefit, state.benefit);
  requireText(RequestField.aimToUse, state.aimToUse);
  requireText(RequestField.whyNotEnough, state.whyNotEnough);
  requireText(RequestField.notEnoughComment, state.notEnoughComment);

  //! Email
  final email = state.email.trim();
  if (email.isEmpty) {
    errors[RequestField.email] = localization.fieldRequired;
  } else if (!_emailRegExp.hasMatch(email)) {
    errors[RequestField.email] = localization.invalidEmail;
  }

  //! Telefon
  final phone = state.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  if (phone.isEmpty) {
    errors[RequestField.phoneNumber] = localization.fieldRequired;
  } else if (phone.replaceAll('+', '').length < 9) {
    errors[RequestField.phoneNumber] = localization.invalidPhoneNumber;
  }

  //! Hisobot
  if (state.dataReport == null) {
    errors[RequestField.dataReport] = localization.fieldRequired;
  }

  //! Sanalar
  final from = state.dateFrom;
  final to = state.dateTo;
  if (from == null) errors[RequestField.dateFrom] = localization.fieldRequired;
  if (to == null) errors[RequestField.dateTo] = localization.fieldRequired;
  if (from != null && to != null && from.isAfter(to)) {
    errors[RequestField.dateFrom] = localization.dateRangeInvalid;
    errors[RequestField.dateTo] = localization.dateRangeInvalid;
  }

  return errors;
}
