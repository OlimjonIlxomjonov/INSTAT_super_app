import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class DropDownModel extends DropDownEntity {
  DropDownModel({
    required super.id,
    required super.name,
    required super.isActive,
    required super.createdAt,
  });

  factory DropDownModel.fromJson(Map<String, dynamic> json) {
    return DropDownModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
