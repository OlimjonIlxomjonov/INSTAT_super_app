import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_expert_entity.dart';

class ArticleBriefEntity {
  final int id;
  final String title;
  final String status;
  final UserArticlesExpertEntity? expert;
  final int likesCount;
  final int dislikesCount;
  final int quotesCount;
  final int downloadCount;
  final DateTime? createdAt;

  const ArticleBriefEntity({
    required this.id,
    this.title = '',
    this.status = '',
    this.expert,
    this.likesCount = 0,
    this.dislikesCount = 0,
    this.quotesCount = 0,
    this.downloadCount = 0,
    this.createdAt,
  });
}
