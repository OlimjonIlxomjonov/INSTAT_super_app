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
  final bool isSaved;

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
    this.isSaved = false,
  });

  BookEntity copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
    String? type,
    BookCategoryEntity? category,
    int? price,
    BookAuthorEntity? author,
    int? pagesCount,
    String? createdAt,
    int? userBookCount,
    int? inCartCount,
    List<BookThumbnailEntity>? bookThumbnails,
    bool? isSaved,
  }) {
    return BookEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      category: category ?? this.category,
      price: price ?? this.price,
      author: author ?? this.author,
      pagesCount: pagesCount ?? this.pagesCount,
      createdAt: createdAt ?? this.createdAt,
      userBookCount: userBookCount ?? this.userBookCount,
      inCartCount: inCartCount ?? this.inCartCount,
      bookThumbnails: bookThumbnails ?? this.bookThumbnails,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
