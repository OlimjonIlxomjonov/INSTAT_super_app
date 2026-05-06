import 'package:my_template/features/education_app/features/user_courses_edu/data/models/offline_course/offline_group_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/offline_course/offline_course_response.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';

class OfflineCourseResponseModel extends OfflineCourseResponse {
  OfflineCourseResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory OfflineCourseResponseModel.fromJson(Map<String, dynamic> json) {
    return OfflineCourseResponseModel(
      links: LinksModel.fromJson(json['links'] as Map<String, dynamic>),
      data: (json['data'] as List)
          .map(
            (item) => OfflineGroupModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
