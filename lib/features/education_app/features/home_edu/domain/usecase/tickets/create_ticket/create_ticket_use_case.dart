import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class CreateTicketUseCase {
  final HomeEduRepository repository;

  CreateTicketUseCase({required this.repository});

  Future<void> call({required CreateTicketParams params}) {
    return repository.createTicket(params: params);
  }
}
