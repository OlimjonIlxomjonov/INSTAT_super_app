import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class AddCourseCommentUseCase {
  final HomeEduRepository repository;

  AddCourseCommentUseCase({required this.repository});

  Future<void> call({required AddCourseCommentParams params}) {
    return repository.addCourseComment(params: params);
  }
}
