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
    required super.orderCount,
    required super.commentCount,
    required super.starsSum,
    required super.currentPage,
    required super.status,
  });

  factory OfflineBookModel.fromJson(Map<String, dynamic> json) {
    final bookJson = json['book'] as Map<String, dynamic>? ?? json;
    return OfflineBookModel(
      id: bookJson['id'],
      name: bookJson['name'] ?? '',
      description: bookJson['description'] ?? '',
      isActive: bookJson['is_active'] ?? false,
      type: bookJson['type'] ?? '',
      category: BookCategoryModel.fromJson(bookJson['category'] ?? {}),
      price: bookJson['price'] ?? 0,
      author: BookAuthorModel.fromJson(bookJson['author'] ?? {}),
      pagesCount: json['pages_count'] ?? bookJson['pages_count'] ?? 0,
      createdAt: bookJson['created_at'] ?? '',
      userBookCount:
          json['user_book_count'] ?? bookJson['user_book_count'] ?? 0,
      inCartCount: json['in_cart_count'] ?? bookJson['in_cart_count'] ?? 0,
      copiesCount: json['copies_count'] ?? bookJson['copies_count'] ?? 0,
      notPostedCount:
          json['not_posted_count'] ?? bookJson['not_posted_count'] ?? 0,
      inLoanCount: json['in_loan_count'] ?? bookJson['in_loan_count'] ?? 0,
      isSaved:
          (json['user_book_count'] ?? bookJson['user_book_count'] ?? 0) >= 1,
      isInCart: (json['in_cart_count'] ?? bookJson['in_cart_count'] ?? 0) >= 1,
      bookThumbnails:
          (bookJson['book_thumbnails'] as List?)
              ?.map((e) => BookThumbnailModel.fromJson(e))
              .toList() ??
          [],
      orderCount: json['orders_count'] ?? bookJson['orders_count'] ?? 0,
      commentCount: json['comments_count'] ?? bookJson['comments_count'] ?? 0,
      starsSum: json['stars_sum'] ?? bookJson['stars_sum'] ?? 0,
      currentPage: json['current_page'] ?? bookJson['current_page'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
