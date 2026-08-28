import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';

class NotifModel extends NotifEntity {
  NotifModel({
    required super.id,
    required super.title,
    required super.link,
    required super.message,
    required super.isRead,
    required super.createdAt,
  });

  factory NotifModel.fromJson(Map<String, dynamic> json) {
    return NotifModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      message: json['message'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
