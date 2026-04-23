import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';

abstract class LeaderBoardRepository {
  Future<LeaderBoardResponse> getLeaderBoard();
}
