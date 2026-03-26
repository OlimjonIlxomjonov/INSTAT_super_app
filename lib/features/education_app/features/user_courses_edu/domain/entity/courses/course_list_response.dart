import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class CourseListResponse {
  final Links links;
  final List<CourseEntity> data;
  final Meta meta;

  CourseListResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
