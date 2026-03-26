import 'package:my_template/features/main_app/home/domain/entity/user_me/user_groups_entity.dart';

class UserGroupsModel extends UserGroupsEntity {
  UserGroupsModel({
    required super.id,
    required super.name,
    required super.permissions,
  });

  factory UserGroupsModel.fromJson(Map<String, dynamic> json) {
    return UserGroupsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      permissions: List<int>.from(json['permissions'] ?? []),
    );
  }
}
