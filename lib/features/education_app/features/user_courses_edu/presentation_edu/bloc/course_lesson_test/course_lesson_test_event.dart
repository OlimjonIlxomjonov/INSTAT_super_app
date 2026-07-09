import 'package:my_template/core/common/params/edu_params/params.dart';

abstract class CourseLessonTestEvent {
  const CourseLessonTestEvent();
}

class LoadCourseLessonTestsEvent extends CourseLessonTestEvent {
  final CourseLessonTestParams params;

  const LoadCourseLessonTestsEvent({required this.params});
}

class SelectLessonTestOptionEvent extends CourseLessonTestEvent {
  final int optionId;

  const SelectLessonTestOptionEvent({required this.optionId});
}

class SubmitLessonTestAnswerEvent extends CourseLessonTestEvent {
  final String? proctorImage;

  const SubmitLessonTestAnswerEvent({this.proctorImage});
}

class NextLessonTestQuestionEvent extends CourseLessonTestEvent {}
