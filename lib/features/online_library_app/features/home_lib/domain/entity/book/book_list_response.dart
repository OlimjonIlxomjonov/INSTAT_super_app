import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/entity/offline_book_entity.dart';

class BookListResponse {
  final List<OfflineBookEntity> data;

  BookListResponse({required this.data});
}
