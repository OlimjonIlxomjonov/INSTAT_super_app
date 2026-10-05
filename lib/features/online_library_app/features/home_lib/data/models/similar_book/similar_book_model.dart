import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/similar_book/similar_book_entity.dart';

class SimilarBookModel extends SimilarBookEntity {
  const SimilarBookModel({
    required super.id,
    super.name,
    super.type,
    super.price,
    super.categoryId,
  });

  factory SimilarBookModel.fromJson(Map<String, dynamic> json) {
    return SimilarBookModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      categoryId: json['category'] is int ? json['category'] : 0,
    );
  }
}
