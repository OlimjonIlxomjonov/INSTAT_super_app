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
}
