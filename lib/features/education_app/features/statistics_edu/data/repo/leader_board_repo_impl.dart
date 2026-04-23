import 'package:my_template/features/education_app/features/statistics_edu/data/source/remote_data_source/leader_board_remote_data_source.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';

class LeaderBoardRepoImpl implements LeaderBoardRepository {
  final LeaderBoardRemoteDataSource _remote;

  LeaderBoardRepoImpl({required LeaderBoardRemoteDataSource remote})
    : _remote = remote;

  @override
  Future<LeaderBoardResponse> getLeaderBoard() {
    return _remote.fetchLeaderBoard();
  }
}
