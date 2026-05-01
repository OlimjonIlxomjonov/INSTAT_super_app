import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comment_user_entity.dart';

class CommentsUserModel extends CommentUserEntity {
  CommentsUserModel({
    required super.id,
    super.avatar,
    super.firstName,
    super.lastName,
  });

  factory CommentsUserModel.fromJson(Map<String, dynamic> json) {
    return CommentsUserModel(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
