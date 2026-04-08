class LessonTestEntity {
  final int id;
  final String question;
  final String questionUz;
  final String questionRu;
  final String questionEn;
  final int lesson;
  final String thumbnail;
  final String createdAt;

  LessonTestEntity({
    required this.id,
    required this.question,
    required this.questionUz,
    required this.questionRu,
    required this.questionEn,
    required this.lesson,
    required this.thumbnail,
    required this.createdAt,
  });
}
