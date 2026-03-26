import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_topics/course_lesson_topics_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';

class CourseLessonTopicsResponseModel extends CourseLessonTopicsResponse {
  CourseLessonTopicsResponseModel({required super.data});

  factory CourseLessonTopicsResponseModel.fromJson(List<dynamic> json) {
    return CourseLessonTopicsResponseModel(
      data: json.map((e) => CourseLessonTopicsModel.fromJson(e)).toList(),
    );
  }
}
