import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_expert_entity.dart';

class ArticleProcessEntity {
  final String? file;
  final String status;
  final String comment;
  final ArticleProcessExpertEntity expert;
  final int cycle;
  final DateTime createdAt;
  final int id;
  final int? fileSize;

  const ArticleProcessEntity({
    required this.file,
    required this.status,
    required this.comment,
    required this.expert,
    required this.cycle,
    required this.createdAt,
    required this.id,
    required this.fileSize,
  });


}
