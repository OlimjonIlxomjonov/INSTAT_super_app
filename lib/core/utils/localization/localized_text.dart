/// Picks the right localized variant of backend-provided text for the app's
/// current language.
///
/// Many API responses in this app (courses, categories, books, reports, ...)
/// send a resource's name/description in four parallel fields —
/// `name`/`name_uz`/`name_ru`/`name_en` — rather than switching based on an
/// `Accept-Language` header. [fallback] should be the plain `name`/
/// `description` field, which the backend always sends in Uzbek; it is also
/// the value used whenever the field requested by [localeCode] is missing
/// or blank (untranslated content, or a locale the backend doesn't cover).
///
/// `uz_Cyrl` also resolves to `languageCode == 'uz'` (confirmed in
/// `LanguageServiceStorage._decode`), and the backend only ever sends one
/// Uzbek field, so switching on plain `localeCode` already covers both
/// Uzbek variants correctly — there is no separate Cyrillic field to pick.
String localizedText({
  required String localeCode,
  required String fallback,
  String? uz,
  String? ru,
  String? en,
}) {
  String pick(String? value) =>
      (value != null && value.isNotEmpty) ? value : fallback;

  switch (localeCode) {
    case 'ru':
      return pick(ru);
    case 'en':
      return pick(en);
    default:
      return pick(uz);
  }
}

/// Same field-selection logic as [localizedText], but returns `null`
/// instead of substituting a different language when the requested
/// locale's field is missing or blank.
///
/// Meant for content where showing nothing — or an explicit "not
/// available" message chosen by the caller — is better than silently
/// falling back: a whole paragraph of the wrong language reads as broken
/// rather than intentional, unlike a short title/name, which should
/// always show something recognizable via [localizedText] instead.
String? localizedTextOrNull({
  required String localeCode,
  String? uz,
  String? ru,
  String? en,
}) {
  String? pick(String? value) =>
      (value != null && value.isNotEmpty) ? value : null;

  switch (localeCode) {
    case 'ru':
      return pick(ru);
    case 'en':
      return pick(en);
    default:
      return pick(uz);
  }
}
