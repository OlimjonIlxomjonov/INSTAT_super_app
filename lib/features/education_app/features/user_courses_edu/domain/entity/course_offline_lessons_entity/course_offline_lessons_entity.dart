class CourseOfflineLessonsEntity {
  final int id;
  final String title;
  final String? titleUz;
  final String? titleRu;
  final String? titleEn;
  final String? descriptionUz;
  final String? descriptionRu;
  final String? descriptionEn;
  final bool isActive;
  final String thumbnail;
  final String? hlsFolder;
  final String status;
  final int duration;
  final DateTime createdAt;
  final double progress;
  final int courseBlock;

  const CourseOfflineLessonsEntity({
    required this.id,
    required this.title,
    this.titleUz,
    this.titleRu,
    this.titleEn,
    this.descriptionUz,
    this.descriptionRu,
    this.descriptionEn,
    required this.isActive,
    required this.thumbnail,
    this.hlsFolder,
    required this.status,
    required this.duration,
    required this.createdAt,
    required this.progress,
    required this.courseBlock,
  });


}
