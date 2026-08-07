import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_expert_entity.dart';

class EditionArticleEntity {
  final int id;
  final int order;
  final EditionArticleReviewEntity review;

  const EditionArticleEntity({
    required this.id,
    required this.order,
    required this.review,
  });
}

class EditionArticleReviewEntity {
  final int id;
  final String title;
  final String status;
  final UserArticlesExpertEntity? expert;
  final List<ReviewAuthorEntity> reviewAuthors;
  final DateTime? createdAt;

  const EditionArticleReviewEntity({
    required this.id,
    required this.title,
    required this.status,
    this.expert,
    this.reviewAuthors = const [],
    this.createdAt,
  });
}
