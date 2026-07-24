import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_page_entity.dart';

class BookPageModel extends BookPageEntity {
  BookPageModel({required super.id, required super.pageNumber});

  factory BookPageModel.fromJson(Map<String, dynamic> json) {
    return BookPageModel(
      id: json['id'] ?? 0,
      pageNumber: json['page_number'] ?? 0,
    );
  }
}
