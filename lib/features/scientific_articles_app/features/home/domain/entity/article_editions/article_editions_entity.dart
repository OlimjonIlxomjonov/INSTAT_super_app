class ArticleEditionsEntity {
  final int id;
  final String? title;
  final int? year;
  final int? number;
  final bool? isActive;
  final String? thumbnail;
  final String? createdAt;

  ArticleEditionsEntity({
    required this.id,
    this.title,
    this.year,
    this.number,
    this.isActive,
    this.thumbnail,
    this.createdAt,
  });
}
