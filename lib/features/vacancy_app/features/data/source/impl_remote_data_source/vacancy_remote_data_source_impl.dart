import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_application_params.dart';
import 'package:my_template/core/common/params/vacancy_params/vacancy_params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/vacancy_app/features/data/model/application/vacancy_application_list_response_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/application/vacancy_process_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/vacancy/vacancy_list_response_model.dart';
import 'package:my_template/features/vacancy_app/features/data/source/remote_data_source/vacancy_remote_data_source.dart';

class VacancyRemoteDataSourceImpl implements VacancyRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<VacancyListResponseModel> fetchVacancies({
    required VacancyListParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.vacancies,
        queryParams: {
          'page': params.page,
          if (params.search.isNotEmpty) 'search': params.search,
          if (params.employmentType != null)
            'employment_type': params.employmentType,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return VacancyListResponseModel.fromJson(response.data);
      }
      throw Exception('ERROR ${response.statusCode}');
    } on DioException catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<VacancyApplicationListResponseModel> fetchApplications({
    required VacancyApplicationListParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.vacancyApplications,
        queryParams: {
          'page': params.page,
          if (params.search.isNotEmpty) 'search': params.search,
          if (params.status != null) 'status': params.status,
          if (params.vacancyId != null) 'vacancy_id': params.vacancyId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return VacancyApplicationListResponseModel.fromJson(response.data);
      }
      throw Exception('ERROR ${response.statusCode}');
    } on DioException catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<VacancyProcessModel>> fetchProcesses({
    required int applicationId,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.vacancyApplicationProcesses(applicationId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final raw = response.data;
        final list = raw is List ? raw : (raw is Map ? raw['data'] : null);
        return (list as List? ?? [])
            .map((e) => VacancyProcessModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('ERROR ${response.statusCode}');
    } on DioException catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> applyToVacancy({required ApplyVacancyParams params}) async {
    try {
      final birth = params.birthDate;
      final formData = FormData.fromMap({
        'vacancy_id': params.vacancyId,
        'first_name': params.firstName,
        'last_name': params.lastName,
        'birth_date':
            '${birth.year}-${birth.month.toString().padLeft(2, '0')}-${birth.day.toString().padLeft(2, '0')}',
        'phone_number': params.phoneNumber,
        'email': params.email,
        'files': [
          for (final file in params.files)
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
        ],
      });
      final response = await _dioClient.post(
        ApiUrls.vacancyCandidates,
        data: formData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return;
      }
      throw Exception('ERROR ${response.statusCode}');
    } on DioException catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
