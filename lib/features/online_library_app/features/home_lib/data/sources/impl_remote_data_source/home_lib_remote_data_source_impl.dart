import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/home_lib_remote_data_source.dart';

class HomeLibRemoteDataSourceImpl implements HomeLibRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<BookListResponseModel> fetchPopularBooks() async {
    try {
      final response = await _dioClient.get(ApiUrls.activeBooks);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return BookListResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> saveDeleteBook(int id) async {
    try {
      final response = await _dioClient.post('books/$id/save-delete-book/');
      if (response.statusCode != 204 &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
