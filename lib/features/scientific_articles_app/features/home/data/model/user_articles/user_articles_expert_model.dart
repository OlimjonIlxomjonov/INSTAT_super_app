import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_expert_entity.dart';

class UserArticlesExpertModel extends UserArticlesExpertEntity {
  UserArticlesExpertModel({
    required super.id,
    required super.userName,
    required super.email,
    required super.avatar,
    required super.firstName,
    required super.lastName,
  });

  factory UserArticlesExpertModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserArticlesExpertModel(
        id: 0,
        userName: '',
        email: '',
        avatar: '',
        firstName: '',
        lastName: '',
      );
    }
    return UserArticlesExpertModel(
      id: json['id'],
      userName: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
