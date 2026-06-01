import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_entity.dart';

class ArticleEditionsModel extends ArticleEditionsEntity {
  ArticleEditionsModel({
    required super.id,
    super.createdAt,
    super.isActive,
    super.number,
    super.thumbnail,
    super.title,
    super.year,
  });

  factory ArticleEditionsModel.fromJson(Map<String, dynamic> json) {
    return ArticleEditionsModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      year: json['year'] as int?,
      number: json['number'] as int?,
      isActive: json['is_active'] as bool?,
      thumbnail: json['thumbnail'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
