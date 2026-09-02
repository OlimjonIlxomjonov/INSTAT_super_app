import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_user.dart';

class TicketsChatUserModel extends TicketsChatUserEntity {
  TicketsChatUserModel({
    required super.id,
    required super.userName,
    required super.email,
    required super.avatar,
    required super.firstName,
    required super.lastName,
    required super.isVerified,
  });

  factory TicketsChatUserModel.fromJson(Map<String, dynamic> json) {
    return TicketsChatUserModel(
      id: json['id'] ?? 0,
      userName: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? 'Unknown',
      isVerified: json['is_verified'] ?? false,
    );
  }
}
