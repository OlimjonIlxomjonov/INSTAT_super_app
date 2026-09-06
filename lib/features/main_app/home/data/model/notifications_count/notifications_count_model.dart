import 'package:my_template/features/main_app/home/domain/entity/notifications_count/notifications_count_entity.dart';

class NotificationsCountModel extends NotificationsCountEntity {
  NotificationsCountModel({required super.count});

  factory NotificationsCountModel.fromJson(Map<String, dynamic> json) {
    return NotificationsCountModel(count: json['count'] ?? 0);
  }
}
