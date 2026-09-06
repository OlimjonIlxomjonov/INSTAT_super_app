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
}
