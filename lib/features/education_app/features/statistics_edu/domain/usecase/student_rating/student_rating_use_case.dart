import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/repository/leader_board_repository.dart';

class StudentRatingUseCase {
  final LeaderBoardRepository repository;

  StudentRatingUseCase({required this.repository});

  Future<StudentRatingEntity> call(int studentId) =>
      repository.getStudentRating(studentId);
}
