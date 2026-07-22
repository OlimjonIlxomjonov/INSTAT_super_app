import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/models/offline_book_model.dart';

class BookListResponseModel extends BookListResponse {
  BookListResponseModel({required super.data});

  factory BookListResponseModel.fromJson(Map<String, dynamic> json) {
    return BookListResponseModel(
      data: (json['data'] as List)
          .map((e) => OfflineBookModel.fromJson(e))
          .toList(),
    );
  }
}
