import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/remote_data_source/home_edu_remote_data_source.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class HomeEduRepoImpl implements HomeEduRepository {
  final HomeEduRemoteDataSource _remoteDataSource;

  HomeEduRepoImpl({required HomeEduRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<CommentsResponse> getComments({required CommentsParams params}) {
    return _remoteDataSource.fetchComments(params: params);
  }

  @override
  Future<CourseEntity> getPerCourse({required PerCourseParams params}) {
    return _remoteDataSource.fetchPerCourse(params: params);
  }

  //? User Certificate
  @override
  Future<UserCertificateResponse> getUserCertificates() {
    return _remoteDataSource.fetchUserCertificate();
  }

  @override
  Future<List<CourseEntity>> getSimilarCourses({
    required PerCourseParams params,
  }) {
    return _remoteDataSource.fetchSimilarCourses(params: params);
  }

  @override
  Future<ShowTicketsResponse> getTickets({required ShowTicketsParams params}) {
    return _remoteDataSource.fetchTickets(params: params);
  }

  @override
  Future<List<TicketsChatEntity>> getTicketsChat({
    required TicketsChatParams params,
  }) {
    return _remoteDataSource.fetchTicketsChat(params: params);
  }

  @override
  Future<void> sendMessage({required SendMessageParams params}) {
    return _remoteDataSource.sendMessage(params: params);
  }

  @override
  Future<void> createTicket({required CreateTicketParams params}) {
    return _remoteDataSource.createTicket(params: params);
  }

  @override
  Future<void> deleteTicket({required DeleteTicketParams params}) {
    return _remoteDataSource.deleteTicket(params: params);
  }
}
