import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/show_tickets/show_tickets_response_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/tickets_chat/tickets_chat_model.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/user_certificate/user_certificate_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

import '../../../../user_courses_edu/data/models/courses/course_model.dart';

abstract class HomeEduRemoteDataSource {
  Future<CommentsResponseModel> fetchComments({required CommentsParams params});

  Future<CourseEntity> fetchPerCourse({required PerCourseParams params});

  //? User Certificate
  Future<UserCertificateResponseModel> fetchUserCertificate();

  //? Similar Courses
  Future<List<CourseModel>> fetchSimilarCourses({
    required PerCourseParams params,
  });

  //! Tickets
  Future<ShowTicketsResponseModel> fetchTickets({
    required ShowTicketsParams params,
  });

  Future<List<TicketsChatModel>> fetchTicketsChat({
    required TicketsChatParams params,
  });

  Future<void> sendMessage({required SendMessageParams params});

  Future<void> createTicket({required CreateTicketParams params});

  Future<void> deleteTicket({required DeleteTicketParams params});
}
