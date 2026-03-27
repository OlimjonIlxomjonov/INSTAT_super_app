import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_items/course_lesson_items_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_response_entity.dart';

class CourseLessonItemsResponseModel extends CourseLessonItemsResponseEntity {
  const CourseLessonItemsResponseModel({required super.data});

  factory CourseLessonItemsResponseModel.fromJson(List<dynamic> json) {
    return CourseLessonItemsResponseModel(
      data: json.map((e) => CourseLessonItemsModel.fromJson(e)).toList(),
    );
  }
}
