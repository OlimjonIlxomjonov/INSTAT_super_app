import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';

class CourseListResponseModel extends CourseListResponse {
  CourseListResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory CourseListResponseModel.fromJson(Map<String, dynamic> json) {
    return CourseListResponseModel(
      links: LinksModel.fromJson(json['links']),
      data: (json['data'] as List).map((e) => CourseModel.fromJson(e)).toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
