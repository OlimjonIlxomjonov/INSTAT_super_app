import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_expert_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';

class ArticleBriefModel extends ArticleBriefEntity {
  ArticleBriefModel({
    required super.id,
    super.title,
    super.status,
    super.expert,
    super.likesCount,
    super.dislikesCount,
    super.quotesCount,
    super.downloadCount,
    super.createdAt,
  });

  factory ArticleBriefModel.fromJson(Map<String, dynamic> json) {
    return ArticleBriefModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      expert: json['expert'] is Map<String, dynamic>
          ? UserArticlesExpertModel.fromJson(json['expert'])
          : null,
      likesCount: json['likes_count'] ?? 0,
      dislikesCount: json['dislikes_count'] ?? 0,
      quotesCount: json['quotes_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
