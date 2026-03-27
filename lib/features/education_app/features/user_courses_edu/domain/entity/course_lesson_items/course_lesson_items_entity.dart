class CourseLessonItemsEntity {
  final int id;
  final int testsCount;
  final int filesCount;
  final int userLessons;
  final int viewedLessons;
  final String title;
  final String? titleUz;
  final String? titleRu;
  final String? titleEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final bool isActive;
  final String? thumbnail;
  final String? hlsFolder;
  final String status;
  final int duration;
  final DateTime createdAt;
  final double progress;
  final int courseBlock;

  const CourseLessonItemsEntity({
    required this.id,
    required this.testsCount,
    required this.filesCount,
    required this.userLessons,
    required this.viewedLessons,
    required this.title,
    this.titleUz,
    this.titleRu,
    this.titleEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    required this.isActive,
    this.thumbnail,
    this.hlsFolder,
    required this.status,
    required this.duration,
    required this.createdAt,
    required this.progress,
    required this.courseBlock,
  });
}
