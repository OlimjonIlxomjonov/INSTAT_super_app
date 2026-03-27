import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/sertificate_obj_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/user_order_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.price,
    required super.certificateImage,
    required super.isActive,
    required super.thumbnail,
    required super.isOnline,
    required super.category,
    required super.lessonsCount,
    required super.totalDuration,
    required super.testsCount,
    required super.certificateObjects,
    super.nameRu,
    super.descriptionEn,
    super.descriptionRu,
    super.descriptionUz,
    super.nameEn,
    super.nameUz,
    super.userOrder,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      name: json['name'],
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      price: json['price'],
      certificateImage: json['certificate_image'] ?? '',
      isActive: json['is_active'],
      thumbnail: json['thumbnail'],
      isOnline: json['is_online'],
      category: json['category'],
      lessonsCount: json['lessons_count'],
      totalDuration: json['total_duration'],
      testsCount: json['tests_count'],
      userOrder: json['user_order'] != null
          ? UserOrderModel.fromJson(json['user_order'])
          : null,
      certificateObjects:
          (json['certificate_objects'] as List?)
              ?.map((e) => CertificateObjModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
