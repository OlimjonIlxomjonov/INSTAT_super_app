import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class DeleteTicketUseCase {
  final HomeEduRepository repository;

  DeleteTicketUseCase({required this.repository});

  Future<void> call({required DeleteTicketParams params}) {
    return repository.deleteTicket(params: params);
  }
}
