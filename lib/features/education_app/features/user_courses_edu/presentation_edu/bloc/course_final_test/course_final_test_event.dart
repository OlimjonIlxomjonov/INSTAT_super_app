import 'package:my_template/core/common/params/edu_params/params.dart';

abstract class CourseFinalTestEvent {
  const CourseFinalTestEvent();
}

class LoadCourseFinalTestsEvent extends CourseFinalTestEvent {
  final CourseLessonTestParams params;

  const LoadCourseFinalTestsEvent({required this.params});
}

class SelectCourseFinalTestOptionEvent extends CourseFinalTestEvent {
  final int optionId;

  const SelectCourseFinalTestOptionEvent({required this.optionId});
}

class SubmitCourseFinalTestAnswerEvent extends CourseFinalTestEvent {
  final String? proctorImage;

  const SubmitCourseFinalTestAnswerEvent({this.proctorImage});
}

class NextCourseFinalTestQuestionEvent extends CourseFinalTestEvent {}
