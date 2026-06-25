import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_expert_entity.dart';

class UserArticlesEntity {
  final int id;
  final int userId;
  final String title;
  final String status;
  final UserArticlesExpertEntity? expert;
  final DateTime? updatedAt;
  final DateTime? createdAt;

  const UserArticlesEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.status,
    this.expert,
    this.updatedAt,
    this.createdAt,
  });

  ArticleStatus get articleStatus {
    switch (status) {
      case 'pending':
        return ArticleStatus.pending;
      case 'rejected':
      case 'failed':
        return ArticleStatus.rejected;
      case 'draft':
        return ArticleStatus.draft;
      case 'published':
        return ArticleStatus.confirmed;
      case 'in_review':
        return ArticleStatus.inReview;
      default:
        return ArticleStatus.draft;
    }
  }
}
