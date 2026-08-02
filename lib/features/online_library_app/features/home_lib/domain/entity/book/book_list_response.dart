import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/entity/offline_book_entity.dart';

class BookListResponse {
  final List<OfflineBookEntity> data;

  /// Pagination info, when the endpoint provides it.
  ///
  /// Deliberately optional: several sources build this response without any
  /// pagination at all (the cart passes an empty `meta`, and the cart bloc
  /// constructs one directly for optimistic removal). A null meta simply
  /// means "not paginated", which callers treat as "no further pages".
  final Meta? meta;

  BookListResponse({required this.data, this.meta});
}
