import 'package:dio/dio.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/show_tickets/show_tickets_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/tickets_chat/tickets_chat_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/user_certificate/user_certificate_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/remote_data_source/home_edu_remote_data_source.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class HomeEduRemoteDataSourceImpl implements HomeEduRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<CommentsResponseModel> fetchComments({
    required CommentsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}${ApiUrls.userComments}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return CommentsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<CourseEntity> fetchPerCourse({required PerCourseParams params}) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return CourseModel.fromJson(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  //? User Certificate
  @override
  Future<UserCertificateResponseModel> fetchUserCertificate() async {
    try {
      final response = await _dioClient.get(ApiUrls.userCertificate);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data;
        // return data
        //     .map((e) => UserCertificateResponseModel.fromJson(e))
        //     .toList();
        return UserCertificateResponseModel.fromJson(data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> fetchSimilarCourses({
    required PerCourseParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/${ApiUrls.similarCourses}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => CourseModel.fromJson(e)).toList();
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<ShowTicketsResponseModel> fetchTickets({
    required ShowTicketsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.showTickets(params.status, params.search, params.page),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return ShowTicketsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<List<TicketsChatModel>> fetchTicketsChat({
    required TicketsChatParams params,
  }) async {
    try {
      final response = await _dioClient.get(ApiUrls.showTicketChat(params));
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => TicketsChatModel.fromJson(e)).toList();
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<void> sendMessage({required SendMessageParams params}) async {
    try {
      final formData = FormData.fromMap({
        'message': params.message,
        if (params.file != null)
          'file': await MultipartFile.fromFile(
            params.file!.path,
            filename: params.file!.path.split('/').last,
          ),
      });

      final response = await _dioClient.post(
        ApiUrls.sendMessage(params),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<void> createTicket({required CreateTicketParams params}) async {
    try {
      final formData = FormData.fromMap({
        'title': params.title,
        if (params.desc != null) 'description': params.desc,
        'file': await MultipartFile.fromFile(
          params.file.path,
          filename: params.file.path.split('/').last,
        ),
      });

      final response = await _dioClient.post(
        ApiUrls.createTicket,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('Throw Exception (Else): ${response.statusCode}');
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteTicket({required DeleteTicketParams params}) async {
    try {
      final response = await _dioClient.delete(
        "${ApiUrls.deleteTicket}${params.ticketId}/",
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        logger.i(response.data);
      } else {
        throw Exception(
          'Throw Exception (Else): ${response.statusCode}: ${response.data}',
        );
      }
    } catch (e) {
      logger.e("Catch: $e");
      rethrow;
    }
  }
}
