import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/models/offline_book_model.dart';

class BookListResponseModel extends BookListResponse {
  BookListResponseModel({required super.data, super.meta});

  factory BookListResponseModel.fromJson(Map<String, dynamic> json) {
    return BookListResponseModel(
      data: (json['data'] as List)
          .map((e) => OfflineBookModel.fromJson(e))
          .toList(),
      meta: _metaOrNull(json['meta']),
    );
  }

  static Meta? _metaOrNull(dynamic raw) {
    if (raw is! Map) return null;

    final currentPage = raw['current_page'];
    final lastPage = raw['last_page'];
    if (currentPage is! int || lastPage is! int) return null;

    return Meta(
      total: raw['total'] as int? ?? 0,
      perPage: raw['per_page'] as int? ?? 0,
      currentPage: currentPage,
      from: raw['from'] as int? ?? 0,
      to: raw['to'] as int? ?? 0,
      lastPage: lastPage,
    );
  }
}
