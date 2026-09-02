import 'package:my_template/core/common/params/edu_params/params.dart';

class HomeEduEvent {
  const HomeEduEvent();
}

class CommentsEvent extends HomeEduEvent {
  final CommentsParams params;

  CommentsEvent({required this.params});
}

class PerCourseEvent extends HomeEduEvent {
  final PerCourseParams params;

  PerCourseEvent({required this.params});
}

//? User Certificate
class UserCertificateEvent extends HomeEduEvent {
  const UserCertificateEvent();
}

//? Similar Courses
class SimilarCoursesEvent extends HomeEduEvent {
  final PerCourseParams params;

  SimilarCoursesEvent({required this.params});
}

//! Tickets
class ShowTicketsEvent extends HomeEduEvent {
  final ShowTicketsParams params;

  ShowTicketsEvent({required this.params});
}

class TicketsChatEvent extends HomeEduEvent {
  final TicketsChatParams params;

  TicketsChatEvent({required this.params});
}

class SendMessageEvent extends HomeEduEvent {
  final SendMessageParams params;

  SendMessageEvent({required this.params});
}

class CreateTicketsEvent extends HomeEduEvent {
  final CreateTicketParams params;

  CreateTicketsEvent({required this.params});
}

class DeleteTicketEvent extends HomeEduEvent {
  final DeleteTicketParams params;

  DeleteTicketEvent({required this.params});
}
