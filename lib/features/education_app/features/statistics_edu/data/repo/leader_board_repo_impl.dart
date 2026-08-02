import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/statistics_edu/data/source/remote_data_source/leader_board_remote_data_source.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';

class LeaderBoardRepoImpl implements LeaderBoardRepository {
  final LeaderBoardRemoteDataSource _remote;

  LeaderBoardRepoImpl({required LeaderBoardRemoteDataSource remote})
    : _remote = remote;

  @override
  Future<LeaderBoardResponse> getLeaderBoard({int page = 1}) {
    return _remote.fetchLeaderBoard(page: page);
  }

  @override
  Future<LeaderBoardResponse> searchStudents({
    required SearchStudentsParams params,
  }) {
    return _remote.searchStudents(params: params);
  }
}
