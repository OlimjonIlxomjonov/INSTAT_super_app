import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';

class OrderPaymentModel extends OrderPaymentEntity {
  OrderPaymentModel({
    required super.id,
    required super.status,
    required super.redirectUrl,
  });

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
    );
  }
}
