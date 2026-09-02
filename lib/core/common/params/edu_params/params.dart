import 'dart:io';

class NoParams {}

class UserCoursesParams {
  final String state; // all or finished
  final int page;
  final int? perPage;

  UserCoursesParams({required this.state, this.page = 1, this.perPage});
}

class CourseCategoryByIdParams {
  final int id;

  CourseCategoryByIdParams({required this.id});
}

class CourseLessonItemsParams {
  final int courseId;
  final int blockId;

  CourseLessonItemsParams({required this.courseId, required this.blockId});
}

class CoursesParam {
  CoursesParam();
}

class CourseFilesParams {
  final int courseId, topicId, lessonId;

  CourseFilesParams({
    required this.courseId,
    required this.topicId,
    required this.lessonId,
  });
}

class BuyCourseParams {
  final int courseId;
  final String paymentMethod;

  BuyCourseParams({required this.courseId, required this.paymentMethod});
}

class SearchCoursesParams {
  final String search;
  final int page;

  SearchCoursesParams({required this.search, this.page = 1});
}

class SearchBooksParams {
  final String search;
  final int page;

  SearchBooksParams({required this.search, this.page = 1});
}

class SearchStudentsParams {
  final String search;
  final int page;

  SearchStudentsParams({required this.search, this.page = 1});
}

class CourseLessonTestParams {
  final int courseId;
  final int blockId;
  final int lessonId;

  CourseLessonTestParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
  });
}

class CourseLessonTestOptionsParams {
  final int courseId;
  final int blockId;
  final int lessonId;
  final int testId;

  CourseLessonTestOptionsParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
    required this.testId,
  });
}

class SubmitLessonTestAnswerParams {
  final int courseId;
  final int blockId;
  final int lessonId;
  final int testId;
  final int optionId; // Sent as "lesson_test_option" in body
  final String? image;

  SubmitLessonTestAnswerParams({
    required this.courseId,
    required this.blockId,
    required this.lessonId,
    required this.testId,
    required this.optionId,
    this.image,
  });
}

class CheckFinalTestAccessParams {
  final int courseId;

  CheckFinalTestAccessParams({required this.courseId});
}

class LessonVideoProgressParams {
  final String lessonId; // or int
  final int progress;

  LessonVideoProgressParams({required this.lessonId, required this.progress});
}

class AvatarParams {
  final String imagePath;

  AvatarParams({required this.imagePath});
}

class CommentsParams {
  final int courseId;

  CommentsParams({required this.courseId});
}

class CourseGroupDateParams {
  final int courseGroupId;

  CourseGroupDateParams({required this.courseGroupId});
}

class PerCourseParams {
  final int courseId;

  PerCourseParams({required this.courseId});
}

//! scan qr
class ScanQrParams {
  final String id, groupId, barCode;

  const ScanQrParams({
    required this.id,
    required this.groupId,
    required this.barCode,
  });
}

class OfflineLessonsParams {
  final String id, groupId;

  const OfflineLessonsParams({required this.id, required this.groupId});
}

//! face rec
class FaceRecParams {
  final String code;
  final File imgPath;

  FaceRecParams({required this.code, required this.imgPath});
}

//! not-resident (foreign user) account confirmation
class RegisterNotResidentParams {
  final String firstName;
  final String lastName;
  final String middleName;
  final String phoneNumber;
  final String passportNumber;
  final int countryId;
  final File verifiedImage;

  RegisterNotResidentParams({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phoneNumber,
    required this.passportNumber,
    required this.countryId,
    required this.verifiedImage,
  });
}

//! Notifications
class NotifParams {
  final int? page;

  const NotifParams({this.page = 1});
}

//! Tickets
class ShowTicketsParams {
  final String status, search, page;

  ShowTicketsParams({
    required this.status,
    required this.search,
    required this.page,
  });
}

class ModuleCategoryParams {
  final String type, page;

  ModuleCategoryParams({required this.type, required this.page});
}

class TicketsChatParams {
  final int ticketId;

  TicketsChatParams({required this.ticketId});
}

class SendMessageParams {
  final int ticketId;
  final String message;
  final File? file;

  SendMessageParams({required this.ticketId, required this.message, this.file});
}

class CreateTicketParams {
  final String title;
  final String? desc;
  final File file;

  CreateTicketParams({
    required this.title,
    required this.desc,
    required this.file,
  });
}

class DeleteTicketParams {
  final int ticketId;

  DeleteTicketParams({required this.ticketId});
}
