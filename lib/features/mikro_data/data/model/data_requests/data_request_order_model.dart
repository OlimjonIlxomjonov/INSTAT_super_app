import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_order_entity.dart';

class DataRequestOrderModel extends DataRequestOrderEntity {
  const DataRequestOrderModel({
    required super.id,
    required super.status,
    required super.redirectUrl,
  });

  factory DataRequestOrderModel.fromJson(Map<String, dynamic> json) {
    return DataRequestOrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
    );
  }
}
