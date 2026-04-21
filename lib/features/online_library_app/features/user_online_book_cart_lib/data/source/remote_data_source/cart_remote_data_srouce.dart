import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';

abstract class CartRemoteDataSource {
  Future<BookListResponseModel> fetchCart();
}