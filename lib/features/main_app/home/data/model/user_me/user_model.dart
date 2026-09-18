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
    required super.isResident,
    super.birthDate,
    super.birthPlace,
    super.permanentAddress,
    super.temporaryAddress,
    super.phoneNumber,
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

      isResident: json['is_resident'] ?? true,
      birthDate: json['birth_date'],
      birthPlace: json['birth_place'],
      permanentAddress: json['permanent_address'],
      temporaryAddress: json['temporary_address'],
      phoneNumber: json['phone_number'],
    );
  }
}
