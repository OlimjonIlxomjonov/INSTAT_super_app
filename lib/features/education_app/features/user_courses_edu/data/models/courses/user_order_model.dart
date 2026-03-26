import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/user_order_entity.dart';

class UserOrderModel extends UserOrder {
  UserOrderModel({
    required super.id,
    required super.status,
    required super.currentLesson,
    required super.createdAt,
    required super.progress,
    super.paymentMethod,
  });

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    return UserOrderModel(
      id: json['id'],
      paymentMethod: json['payment_method'],
      status: json['status'],
      currentLesson: json['current_lesson'],
      createdAt: json['created_at'],
      progress: (json['progress'] as num).toDouble(),
    );
  }
}
