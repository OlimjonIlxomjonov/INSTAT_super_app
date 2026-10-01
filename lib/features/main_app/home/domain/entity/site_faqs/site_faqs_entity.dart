import 'package:my_template/core/utils/localization/localized_text.dart';

class SiteFaqsEntity {
  final int id;
  final String questionUz,
      questionRu,
      questionEn,
      answerUz,
      answerRu,
      answerEn,
      module;

  SiteFaqsEntity({
    required this.id,
    required this.questionUz,
    required this.questionRu,
    required this.questionEn,
    required this.answerUz,
    required this.answerRu,
    required this.answerEn,
    required this.module,
  });

  String displayQuestion(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: questionUz,
    uz: questionUz,
    ru: questionRu,
    en: questionEn,
  );

  String displayAnswer(String localeCode) => localizedText(
    localeCode: localeCode,
    fallback: answerUz,
    uz: answerUz,
    ru: answerRu,
    en: answerEn,
  );
}
