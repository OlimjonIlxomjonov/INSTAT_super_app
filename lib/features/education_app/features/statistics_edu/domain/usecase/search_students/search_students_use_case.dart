import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';

class SearchStudentsUseCase {
  final LeaderBoardRepository repository;

  SearchStudentsUseCase({required this.repository});

  Future<LeaderBoardResponse> call({required SearchStudentsParams params}) {
    return repository.searchStudents(params: params);
  }
}
