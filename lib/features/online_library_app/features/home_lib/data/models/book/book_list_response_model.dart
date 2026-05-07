import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

class BookListResponseModel extends BookListResponse {
  BookListResponseModel({required super.data});

  factory BookListResponseModel.fromJson(Map<String, dynamic> json) {
    return BookListResponseModel(
      data: (json['data'] as List).map((e) => BookModel.fromJson(e)).toList(),
    );
  }
}
