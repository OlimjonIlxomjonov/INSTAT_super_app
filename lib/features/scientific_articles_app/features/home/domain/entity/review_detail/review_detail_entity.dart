import 'dart:convert';

import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_expert_entity.dart';

class ReviewDetailEntity {
  final int id;
  final String title;
  final int articleType;
  final int journalSection;
  final String? annotationUz;
  final String? annotationRu;
  final String? annotationEn;
  final String? mainFile;
  final int? mainFileSize;
  final String? antiplagiatFile;
  final int? antiplagiatFileSize;
  final String udkCode;
  final String status;
  final String language;
  final UserArticlesExpertEntity? expert;
  final int userId;
  final String keywords; // Raw JSON String of keywords (e.g. '["key","hello"]')
  final DateTime? createdAt;

  const ReviewDetailEntity({
    required this.id,
    required this.title,
    required this.articleType,
    required this.journalSection,
    this.annotationUz,
    this.annotationRu,
    this.annotationEn,
    this.mainFile,
    this.mainFileSize,
    this.antiplagiatFile,
    this.antiplagiatFileSize,
    required this.udkCode,
    required this.status,
    required this.language,
    this.expert,
    required this.userId,
    required this.keywords,
    this.createdAt,
  });

  List<String> get keywordsParsed => List<String>.from(jsonDecode(keywords));

  // Kept in sync with UserArticlesEntity.articleStatus — the two entities
  // represent the same backend `status` field and must map it identically.
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
      case 'confirmed':
      case 'approved':
        return ArticleStatus.confirmed;
      case 'in_review':
        return ArticleStatus.inReview;
      default:
        return ArticleStatus.draft;
    }
  }
}
