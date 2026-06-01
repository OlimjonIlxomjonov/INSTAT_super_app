import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_entity.dart';

import 'article_process_expert_model.dart';

class ArticleProcessModel extends ArticleProcessEntity {
  ArticleProcessModel({
    required super.file,
    required super.status,
    required super.comment,
    required super.expert,
    required super.cycle,
    required super.createdAt,
    required super.id,
    required super.fileSize,
  });

  factory ArticleProcessModel.fromJson(Map<String, dynamic> json) {
    return ArticleProcessModel(
      file: json['file'] as String?,
      status: json['status'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      expert: ArticleProcessExpertModel.fromJson(
        json['expert'] as Map<String, dynamic>? ?? {},
      ),
      cycle: json['cycle'] as int? ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      id: json['id'] as int? ?? 0,
      fileSize: json['file_size'] as int?,
    );
  }
}
