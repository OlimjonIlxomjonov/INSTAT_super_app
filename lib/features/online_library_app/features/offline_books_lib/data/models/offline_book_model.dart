import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_author_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_category_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_thumbnail_model.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/entity/offline_book_entity.dart';

class OfflineBookModel extends OfflineBookEntity {
  OfflineBookModel({
    required super.id,
    required super.name,
    required super.description,
    required super.isActive,
    required super.type,
    required super.category,
    required super.price,
    required super.author,
    required super.pagesCount,
    required super.createdAt,
    required super.userBookCount,
    required super.inCartCount,
    required super.bookThumbnails,
    required super.copiesCount,
    required super.notPostedCount,
    required super.inLoanCount,
    super.isSaved,
    super.isInCart,
  });

  factory OfflineBookModel.fromJson(Map<String, dynamic> json) {
    return OfflineBookModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
      type: json['type'] ?? '',
      category: BookCategoryModel.fromJson(json['category'] ?? {}),
      price: json['price'] ?? 0,
      author: BookAuthorModel.fromJson(json['author'] ?? {}),
      pagesCount: json['pages_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      userBookCount: json['user_book_count'] ?? 0,
      inCartCount: json['in_cart_count'] ?? 0,
      copiesCount: json['copies_count'] ?? 0,
      notPostedCount: json['not_posted_count'] ?? 0,
      inLoanCount: json['in_loan_count'] ?? 0,
      isSaved: (json['user_book_count'] ?? 0) >= 1,
      isInCart: (json['in_cart_count'] ?? 0) >= 1,
      bookThumbnails: (json['book_thumbnails'] as List?)
              ?.map((e) => BookThumbnailModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
