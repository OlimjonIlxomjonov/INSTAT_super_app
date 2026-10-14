import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_order_payment/article_order_payment_entity.dart';

class ArticleOrderPaymentModel extends ArticleOrderPaymentEntity {
  ArticleOrderPaymentModel({
    required super.id,
    required super.status,
    super.code,
    super.merchantId,
    super.serviceId,
    super.amount,
    super.transactionParam,
  });

  factory ArticleOrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return ArticleOrderPaymentModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      // Payme
      code: json['code']?.toString(),
      // Click
      merchantId: json['merchant_id']?.toString(),
      serviceId: json['service_id']?.toString(),
      amount: json['amount']?.toString(),
      transactionParam: json['transaction_param']?.toString(),
    );
  }
}

