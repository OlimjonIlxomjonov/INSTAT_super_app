import 'package:dio/dio.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/models/offline_books_list_response_model.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/source/remote_data_source/offline_books_remote_data_source.dart';

class OfflineBooksRemoteDataSourceImpl implements OfflineBooksRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<OfflineBooksListResponseModel> fetchOfflineBooks({
    String search = '',
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.baseUrl}${ApiUrls.offlineBooks}',
        queryParams: {'search': search, 'page': page},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return OfflineBooksListResponseModel.fromJson(response.data);
      } else {
        throw Exception('THROW Exception (else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      logger.f('${ApiUrls.baseUrl}${ApiUrls.offlineBooks}');
      rethrow;
    }
  }
}
