import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_user_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';

class CommentsModel extends CommentsEntity {
  CommentsModel({
    required super.id,
    required super.user,
    required super.course,
    required super.text,
    required super.stars,
    required super.isActive,
    required super.createdAt,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      id: json['id'] as int? ?? 0,
      user: CommentsUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      course: json['course'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      stars: json['stars'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
