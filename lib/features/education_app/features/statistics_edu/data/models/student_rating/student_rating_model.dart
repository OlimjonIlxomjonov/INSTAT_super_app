import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';

class StudentRatingCertificateModel extends StudentRatingCertificateEntity {
  const StudentRatingCertificateModel({
    required super.id,
    required super.courseName,
    super.imageUrl,
  });

  factory StudentRatingCertificateModel.fromJson(Map<String, dynamic> json) {
    final image = json['image']?.toString();
    return StudentRatingCertificateModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      courseName: json['course_name']?.toString() ?? '',
      imageUrl: image == null || image.isEmpty
          ? null
          : image.startsWith('http')
          ? image
          : '${ApiUrls.origin}$image',
    );
  }
}

class StudentRatingModel extends StudentRatingEntity {
  const StudentRatingModel({
    super.rank,
    required super.scoreSum,
    required super.completedCourseCount,
    required super.activeCourseCount,
    required super.completionRate,
    required super.studyHours,
    required super.certificatesCount,
    required super.certificates,
  });

  factory StudentRatingModel.fromJson(Map<String, dynamic> json) {
    return StudentRatingModel(
      rank: (json['rank'] as num?)?.toInt(),
      scoreSum: (json['score_sum'] as num?)?.toDouble() ?? 0,
      completedCourseCount:
          (json['completed_course_count'] as num?)?.toInt() ?? 0,
      activeCourseCount: (json['active_course_count'] as num?)?.toInt() ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0,
      studyHours: (json['study_hours'] as num?)?.toDouble() ?? 0,
      certificatesCount: (json['certificates_count'] as num?)?.toInt() ?? 0,
      certificates: (json['certificates'] as List? ?? [])
          .map(
            (item) => StudentRatingCertificateModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
