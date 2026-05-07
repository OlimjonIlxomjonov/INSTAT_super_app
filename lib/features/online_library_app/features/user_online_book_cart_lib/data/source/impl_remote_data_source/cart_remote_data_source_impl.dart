import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/data/source/remote_data_source/cart_remote_data_srouce.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<BookListResponseModel> fetchCart() async {
    try {
      final response = await _dioClient.get(ApiUrls.cart);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);

        if (response.data is List) {
          return BookListResponseModel.fromJson({
            'data': response.data,
            'links': <String, dynamic>{},
            'meta': <String, dynamic>{},
          });
        }

        return BookListResponseModel.fromJson(response.data);
      } else {
        throw Exception('Else ERROR OCCURED: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }
}
