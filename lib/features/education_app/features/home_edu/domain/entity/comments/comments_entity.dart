import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comment_user_entity.dart';

class CommentsEntity {
  final int id;
  final CommentUserEntity user;
  final int course;
  final String text;
  final int stars;
  final bool isActive;
  final DateTime createdAt;

  CommentsEntity({
    required this.id,
    required this.user,
    required this.course,
    required this.text,
    required this.stars,
    required this.isActive,
    required this.createdAt,
  });


}
