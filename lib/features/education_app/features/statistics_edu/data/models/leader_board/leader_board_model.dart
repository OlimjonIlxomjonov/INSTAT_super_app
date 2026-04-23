import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_entity.dart';

class LeaderBoardModel extends LeaderBoardEntity {
  LeaderBoardModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.completedCourseCount,
    required super.paidCourseCount,
    required super.certificatesCount,
    required super.scoreSum,
    super.avatar,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LeaderBoardModel(
        id: 0,
        username: '',
        email: '',
        avatar: null,
        firstName: '',
        lastName: '',
        completedCourseCount: 0,
        paidCourseCount: 0,
        certificatesCount: 0,
        scoreSum: 0,
      );
    }

    return LeaderBoardModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] as String?,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      completedCourseCount: json['completed_course_count'] ?? 0,
      paidCourseCount: json['paid_course_count'] ?? 0,
      certificatesCount: json['certificates_count'] ?? 0,
      scoreSum: json['score_sum'] ?? 0,
    );
  }
}
