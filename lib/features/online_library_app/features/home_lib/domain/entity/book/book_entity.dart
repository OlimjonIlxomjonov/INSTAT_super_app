import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_author_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_category_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_thumbnail_entity.dart';

class BookEntity {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final String type;
  final BookCategoryEntity category;
  final int price;
  final BookAuthorEntity author;
  final int pagesCount;
  final String createdAt;
  final int userBookCount;
  final int inCartCount;
  final List<BookThumbnailEntity> bookThumbnails;

  BookEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.type,
    required this.category,
    required this.price,
    required this.author,
    required this.pagesCount,
    required this.createdAt,
    required this.userBookCount,
    required this.inCartCount,
    required this.bookThumbnails,
  });
}
