import 'package:my_template/core/error/exceptions.dart';
import 'package:my_template/core/l10n/app_localizations.dart';

/*
Backend xatoliklarini foydalanuvchiga tushunarli qilib ko'rsatish.

Umumiy "Saqlashda xatolik yuz berdi" o'rniga qaysi maydon muammoli ekanini
aytamiz. Maydon nomi lokalizatsiya qilinadi, xabar matni esa serverdan
kelganicha qoladi (backend inglizcha qaytaradi) — bu tarjima qilinmagan
bo'lsa ham, "xatolik yuz berdi" dan ancha foydaliroq.
*/

String describeRequestError(Object error, AppLocalizations localization) {
  if (error is! ValidationException || error.fieldErrors.isEmpty) {
    return localization.savingError;
  }

  final entry = error.fieldErrors.entries.first;
  final label = _fieldLabel(entry.key, localization);
  final message = entry.value.isNotEmpty ? entry.value.first : '';

  if (message.isEmpty) return label ?? localization.savingError;
  return label == null ? message : '$label: $message';
}

String? _fieldLabel(String field, AppLocalizations localization) {
  switch (field) {
    case 'category':
      return localization.requestCategoryLabel;
    case 'region':
    case 'district':
      return localization.requestAreaLabel;
    case 'full_name':
      return localization.requestFullNameLabel;
    case 'company_name':
      return localization.requestCompanyLabel;
    case 'email':
      return localization.emailLabel;
    case 'phone_number':
      return localization.phoneNumberLabel;
    case 'date_from':
    case 'date_to':
      return localization.requestPeriodLabel;
    case 'description':
      return localization.requestDescriptionLabel;
    case 'aim':
      return localization.requestAimLabel;
    case 'file':
      return localization.requestAttachFileTitle;
    default:
      return null;
  }
}
