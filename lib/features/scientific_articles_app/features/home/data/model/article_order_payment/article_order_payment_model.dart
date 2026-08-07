import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_order_payment/article_order_payment_entity.dart';

class ArticleOrderPaymentModel extends ArticleOrderPaymentEntity {
  ArticleOrderPaymentModel({
    required super.id,
    required super.status,
    required super.redirectUrl,
  });

  factory ArticleOrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return ArticleOrderPaymentModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
    );
  }
}
