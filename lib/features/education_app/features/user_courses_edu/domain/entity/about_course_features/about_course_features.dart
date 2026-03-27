class AboutCourseFeaturesEntity {
  final int id;
  final String text;
  final String? textUz;
  final String? textRu;
  final String? textEn;
  final int course;
  final DateTime createdAt;

  const AboutCourseFeaturesEntity({
    required this.id,
    required this.text,
    this.textUz,
    this.textRu,
    this.textEn,
    required this.course,
    required this.createdAt,
  });


}
