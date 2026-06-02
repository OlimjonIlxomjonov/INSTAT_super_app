import 'package:my_template/core/utils/enums/app_enums.dart';

class UserArticlesEntity {
  final int id;
  final int userId;
  final String title;
  final String status;
  final String? expert;
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
      case 'in_review':
        return ArticleStatus.pending;
      case 'rejected':
      case 'failed':
        return ArticleStatus.rejected;
      case 'draft':
        return ArticleStatus.draft;
      case 'accepted':
        return ArticleStatus.confirmed;
      default:
        return ArticleStatus.draft;
    }
  }
}
