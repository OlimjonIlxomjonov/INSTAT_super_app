import 'package:my_template/features/scientific_articles_app/features/home/data/model/review_authors/review_author_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_expert_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/edition_articles/edition_article_entity.dart';

class EditionArticleModel extends EditionArticleEntity {
  EditionArticleModel({
    required super.id,
    required super.order,
    required super.review,
  });

  factory EditionArticleModel.fromJson(Map<String, dynamic> json) {
    return EditionArticleModel(
      id: json['id'] ?? 0,
      order: json['order'] ?? 0,
      review: EditionArticleReviewModel.fromJson(json['review']),
    );
  }
}

class EditionArticleReviewModel extends EditionArticleReviewEntity {
  EditionArticleReviewModel({
    required super.id,
    required super.title,
    required super.status,
    super.expert,
    super.reviewAuthors,
    super.createdAt,
  });

  factory EditionArticleReviewModel.fromJson(Map<String, dynamic>? json) {
    return EditionArticleReviewModel(
      id: json?['id'] ?? 0,
      title: json?['title'] ?? '',
      status: json?['status'] ?? '',
      expert: json?['expert'] != null
          ? UserArticlesExpertModel.fromJson(json?['expert'])
          : null,
      reviewAuthors:
          (json?['review_authors'] as List?)
              ?.map((e) => ReviewAuthorModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
    );
  }
}
