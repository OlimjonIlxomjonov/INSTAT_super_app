import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';

class BookListResponse {
  final Links links;
  final List<BookEntity> data;
  final Meta meta;

  BookListResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
