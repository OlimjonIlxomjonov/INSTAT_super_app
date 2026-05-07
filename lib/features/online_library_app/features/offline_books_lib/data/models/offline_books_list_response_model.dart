import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/models/offline_book_model.dart';

class OfflineBooksListResponseModel extends BookListResponse {
  OfflineBooksListResponseModel({required super.data});

  factory OfflineBooksListResponseModel.fromJson(Map<String, dynamic> json) {
    return OfflineBooksListResponseModel(
      data: (json['data'] as List).map((e) => OfflineBookModel.fromJson(e)).toList(),
    );
  }
}
