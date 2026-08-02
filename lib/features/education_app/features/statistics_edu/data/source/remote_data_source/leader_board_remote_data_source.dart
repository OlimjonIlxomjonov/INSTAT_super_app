import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/models/leader_board/leader_board_response_model.dart';

abstract class LeaderBoardRemoteDataSource {
  Future<LeaderBoardResponseModel> fetchLeaderBoard({int page = 1});

  Future<LeaderBoardResponseModel> searchStudents({
    required SearchStudentsParams params,
  });
}