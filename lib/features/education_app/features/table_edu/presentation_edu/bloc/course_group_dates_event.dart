import 'package:my_template/core/common/params/edu_params/params.dart';

abstract class CourseGroupDatesEvent {
  const CourseGroupDatesEvent();
}

class FetchCourseGroupDatesEvent extends CourseGroupDatesEvent {
  final CourseGroupDateParams params;

  const FetchCourseGroupDatesEvent({required this.params});
}
