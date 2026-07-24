import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_pages_count_entity.dart';

class BookPagesCountModel extends BookPagesCountEntity {
  BookPagesCountModel({required super.pagesCount, required super.currentPage});

  factory BookPagesCountModel.fromJson(Map<String, dynamic> json) {
    return BookPagesCountModel(
      pagesCount: json['pages_count'] ?? 0,
      currentPage: json['current_page'] ?? 1,
    );
  }
}
