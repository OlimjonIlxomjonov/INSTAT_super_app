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
      case 'confirmed':
      case 'approved':
      case 'published':
        return ArticleStatus.confirmed;
      case 'rejected':
      case 'failed':
        return ArticleStatus.rejected;
      case 'in_review':
      case 'pending':
      default:
        return ArticleStatus.pending;
    }
  }
}
