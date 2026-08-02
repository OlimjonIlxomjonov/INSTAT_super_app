import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_requests_response_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_response_model.dart';
import 'package:my_template/features/mikro_data/data/source/remote_data_source/micro_remote_data_source.dart';

class MicroRemoteDataSourceImpl implements MicroRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<ReportsResponseModel> fetchReportsCard() async {
    try {
      final response = await _dioClient.get(ApiUrls.reports);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ReportsResponseModel.fromJson(response.data);
      } else {
        throw Exception('ELSE ERROR: ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<DataRequestsResponseModel> fetchDataRequests({
    required String status,
    required String search,
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.dataRequests,
        // status bo'sh bo'lsa backend hammasini qaytaradi.
        queryParams: {'status': status, 'search': search, 'page': page},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestsResponseModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }
}
