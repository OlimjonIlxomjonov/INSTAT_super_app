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
