import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/udk/udk_entity.dart';

class UdkModel extends UdkEntity {
  UdkModel({
    required super.id,
    required super.title,
    required super.code,
    required super.createdAt,
  });

  factory UdkModel.fromJson(Map<String, dynamic> json) {
    return UdkModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      createdAt: json['created-at'] ?? DateTime.now(),
    );
  }
}
