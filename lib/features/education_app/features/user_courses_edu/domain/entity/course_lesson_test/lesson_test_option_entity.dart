import 'package:my_template/core/utils/localization/localized_text.dart';

class LessonTestOptionEntity {
  final int id;
  final String text;
  final String textUz;
  final String textRu;
  final String textEn;
  final int lessonTest;
  final String createdAt;

  LessonTestOptionEntity({
    required this.id,
    required this.text,
    required this.textUz,
    required this.textRu,
    required this.textEn,
    required this.lessonTest,
    required this.createdAt,
  });

  String displayText(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: text,
    uz: textUz,
    ru: textRu,
    en: textEn,
  );
}
