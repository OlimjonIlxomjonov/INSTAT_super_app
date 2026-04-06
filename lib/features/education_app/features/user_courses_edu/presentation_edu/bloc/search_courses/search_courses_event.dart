import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class SearchCoursesEvent extends CoursesEvent {
  final SearchCoursesParams params;

  SearchCoursesEvent({required this.params});
}
