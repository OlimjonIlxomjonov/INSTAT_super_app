import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_group_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class OfflineCourseResponse {
  final Links links;
  final List<OfflineGroupEntity> data;
  final Meta meta;

  OfflineCourseResponse({
    required this.links,
    required this.data,
    required this.meta,
  });


}
