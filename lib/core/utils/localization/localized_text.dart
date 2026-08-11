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
