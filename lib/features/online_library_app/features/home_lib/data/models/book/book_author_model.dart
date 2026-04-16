import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_author_entity.dart';

class BookAuthorModel extends BookAuthorEntity {
  BookAuthorModel({
    required super.id,
    required super.name,
    super.image,
    required super.createdAt,
  });

  factory BookAuthorModel.fromJson(Map<String, dynamic> json) {
    return BookAuthorModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
