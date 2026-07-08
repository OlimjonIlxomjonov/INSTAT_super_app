import 'package:my_template/features/main_app/home/data/model/user_me/user_groups_model.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.groups,
    required super.isSuperuser,
    super.avatar,
    required super.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      groups: (json['groups'] as List? ?? [])
          .map((e) => UserGroupsModel.fromJson(e))
          .toList(),
      isSuperuser: json['is_superuser'] ?? false,
      isVerified: json['is_verified'] ?? false,
    );
  }
}
