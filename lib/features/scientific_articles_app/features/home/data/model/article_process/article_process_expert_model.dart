import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_process/article_process_expert_entity.dart';

class ArticleProcessExpertModel extends ArticleProcessExpertEntity {
  ArticleProcessExpertModel({
    required super.id,
    required super.username,
    required super.email,
    required super.avatar,
    required super.firstName,
    required super.lastName,
  });

  factory ArticleProcessExpertModel.fromJson(Map<String, dynamic> json) {
    return ArticleProcessExpertModel(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
    );
  }
}
