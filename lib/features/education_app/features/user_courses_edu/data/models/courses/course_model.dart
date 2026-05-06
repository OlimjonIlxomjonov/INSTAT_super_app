import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/sertificate_obj_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/user_order_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.price,
    required super.isActive,
    required super.thumbnail,
    required super.isOnline,
    required super.category,
    required super.lessonsCount,
    required super.totalDuration,
    super.certificateImage,
    super.testsCount,
    super.ratingsCount,
    super.ratingSum,
    super.score,
    super.nameRu,
    super.descriptionEn,
    super.descriptionRu,
    super.descriptionUz,
    super.nameEn,
    super.nameUz,
    super.userOrder,
    super.certificateObjects,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // category can be an int (detail endpoint) or a Map (list endpoint)
    final categoryRaw = json['category'];
    final int categoryId = categoryRaw is Map
        ? (categoryRaw['id'] as int)
        : (categoryRaw as int);

    return CourseModel(
      id: json['id'] ?? 0,
      name: json['name'],
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      nameEn: json['name_en'],
      descriptionUz: json['description_uz'],
      descriptionRu: json['description_ru'],
      descriptionEn: json['description_en'],
      price: json['price'],
      certificateImage: json['certificate_image'],
      isActive: json['is_active'],
      thumbnail: json['thumbnail'],
      isOnline: json['is_online'],
      category: categoryId,
      lessonsCount: json['lessons_count'] ?? 0,
      totalDuration: json['total_duration'] ?? 0,
      testsCount: json['tests_count'],
      ratingsCount: json['ratings_count'],
      ratingSum: json['rating_sum'],
      score: json['score'],
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
