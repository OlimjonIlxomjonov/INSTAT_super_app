import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/core/error/api_validation_parser.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_category_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_detail_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_process_model.dart';
import 'package:my_template/features/mikro_data/data/model/data_requests/data_requests_response_model.dart';
import 'package:my_template/features/mikro_data/data/model/regions/region_model.dart';
import 'package:my_template/features/mikro_data/data/model/report_files/report_files_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/reports_options_model.dart';
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
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReportsOptionsModel>> fetchReportOptions(int reportId) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.reports}$reportId/options/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final list = response.data['data'] as List?;
        return list
                ?.map(
                  (e) =>
                      ReportsOptionsModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [];
      } else {
        throw Exception('ELSE ERROR: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
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
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<DataRequestCategoryModel>> fetchMicroDataCategories() async {
    try {
      final response = await _dioClient.get(ApiUrls.microDataCategories);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DataRequestCategoryModel.listFromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchRegions() async {
    try {
      final response = await _dioClient.get(ApiUrls.regions);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegionModel.listFromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<DataRequestDetailModel> fetchDataRequest(int requestId) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.dataRequests}$requestId/',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<DataRequestDetailModel> createDataRequest(
    DataRequestParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiUrls.dataRequests,
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<DataRequestDetailModel> updateDataRequest(
    DataRequestParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        '${ApiUrls.dataRequests}${params.id}/',
        data: params.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<DataRequestDetailModel> uploadDataRequestFile(
    UploadDataRequestFileParams params,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          params.file.path,
          filename: params.file.path.split('/').last,
        ),
      });
      final response = await _dioClient.post(
        '${ApiUrls.dataRequests}${params.requestId}/'
        '${ApiUrls.dataRequestUploadFile}',
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestDetailModel.fromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<void> sendDataRequest(int requestId) async {
    try {
      final response = await _dioClient.post(
        '${ApiUrls.dataRequests}$requestId/${ApiUrls.dataRequestSend}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<DataRequestProcessModel>> fetchDataRequestProcesses(
    int requestId,
  ) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.dataRequests}$requestId/${ApiUrls.dataRequestProcesses}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return DataRequestProcessModel.listFromJson(response.data);
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("CATCH: $e");
      throw ApiValidationParser.tryParse(e.response?.data) ?? e;
    } catch (e) {
      logger.e("CATCH: $e");
      rethrow;
    }
  }

  @override
  Future<List<ReportFilesModel>> fetchReportFiles({
    required ReportFilesParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.reportFiles(params.reportId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => ReportFilesModel.fromJson(e)).toList();
      } else {
        throw Exception('THROW EXCEPTION! ${response.statusCode}');
      }
    } catch (e, t) {
      logger.e('CATCH: $e');
      logger.e('TRACK: $t');
      rethrow;
    }
  }
}
