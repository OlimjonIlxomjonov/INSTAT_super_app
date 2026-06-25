import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_expert_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_entity.dart';

class UserArticlesModel extends UserArticlesEntity {
  UserArticlesModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.status,
    super.createdAt,
    super.expert,
    super.updatedAt,
  });

  factory UserArticlesModel.fromJson(Map<String, dynamic>? json) {
    return UserArticlesModel(
      id: json?['id'] ?? 0,
      userId: json?['user_id'] ?? 0,
      title: json?['title'] ?? '',
      status: json?['status'] ?? '',
      expert: UserArticlesExpertModel.fromJson(json?['expert'] ?? null),
      updatedAt: DateTime.tryParse(json?['updated_at']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
    );
  }
}
