import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';

abstract class LeaderBoardRepository {
  Future<LeaderBoardResponse> getLeaderBoard({int page = 1});

  Future<LeaderBoardResponse> searchStudents({
    required SearchStudentsParams params,
  });

  Future<StudentRatingEntity> getStudentRating(int studentId);
}
