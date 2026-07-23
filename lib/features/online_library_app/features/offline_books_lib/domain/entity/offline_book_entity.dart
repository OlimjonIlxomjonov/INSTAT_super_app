import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';

class OfflineBookEntity extends BookEntity {
  final int copiesCount;
  final int notPostedCount;
  final int inLoanCount;

  OfflineBookEntity({
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
    required this.copiesCount,
    required this.notPostedCount,
    required this.inLoanCount,
    super.isSaved,
    super.isInCart,
    required super.orderCount,
    required super.commentCount,
    required super.starsSum,
    required super.currentPage,
  });
}
