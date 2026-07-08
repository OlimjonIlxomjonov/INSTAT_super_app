import 'package:my_template/features/main_app/home/domain/entity/user_me/user_groups_entity.dart';

class UserEntity {
  final int id;
  final String username;
  final String email;
  final String? avatar;
  final String firstName;
  final String lastName;
  final List<UserGroupsEntity> groups;
  final bool isSuperuser;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.firstName,
    required this.lastName,
    required this.groups,
    required this.isSuperuser,
    required this.isVerified,
  });
}
