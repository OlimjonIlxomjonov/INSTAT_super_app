import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';

class LeaderBoardUseCase {
  final LeaderBoardRepository repository;

  LeaderBoardUseCase({required this.repository});

  Future<LeaderBoardResponse> call() {
    return repository.getLeaderBoard();
  }
}
