class CourseLessonTopicsEntity {
  final int id;
  final String text;
  final String? textUz;
  final String? textRu;
  final String? textEn;
  final int course;
  final bool isActive;
  final int totalDuration;
  final int lessonFilesCount;
  final int lessonsCount;
  final int lessonsTestsCount;
  final DateTime createdAt;

  const CourseLessonTopicsEntity({
    required this.id,
    required this.text,
    this.textUz,
    this.textRu,
    this.textEn,
    required this.course,
    required this.isActive,
    required this.totalDuration,
    required this.lessonFilesCount,
    required this.lessonsCount,
    required this.lessonsTestsCount,
    required this.createdAt,
  });
}
