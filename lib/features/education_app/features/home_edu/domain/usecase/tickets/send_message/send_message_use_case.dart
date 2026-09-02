import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class SendMessageUseCase {
  final HomeEduRepository repository;

  SendMessageUseCase({required this.repository});

  Future<void> call({required SendMessageParams params}) {
    return repository.sendMessage(params: params);
  }
}
