import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_category_entity.dart';

class BookCategoryModel extends BookCategoryEntity {
  BookCategoryModel({
    required super.id,
    required super.name,
    super.nameUz,
    super.nameRu,
    super.nameEn,
    super.descriptionUz,
    super.descriptionRu,
    super.descriptionEn,
    super.thumbnail,
    required super.type,
    required super.createdAt,
  });

  factory BookCategoryModel.fromJson(Map<String, dynamic> json) {
    return BookCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      thumbnail: json['thumbnail'],
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
