import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

import '../entity/tickets/show_tickets/show_tickets_response.dart';

abstract class HomeEduRepository {
  Future<CommentsResponse> getComments({required CommentsParams params});

  Future<CourseEntity> getPerCourse({required PerCourseParams params});

  //? User Certificates
  Future<UserCertificateResponse> getUserCertificates();

  //? Similar Courses
  Future<List<CourseEntity>> getSimilarCourses({
    required PerCourseParams params,
  });

  //! Tickets
  Future<ShowTicketsResponse> getTickets({required ShowTicketsParams params});

  Future<List<TicketsChatEntity>> getTicketsChat({
    required TicketsChatParams params,
  });

  Future<void> sendMessage({required SendMessageParams params});

  Future<void> createTicket({required CreateTicketParams params});

  Future<void> deleteTicket({required DeleteTicketParams params});
}
