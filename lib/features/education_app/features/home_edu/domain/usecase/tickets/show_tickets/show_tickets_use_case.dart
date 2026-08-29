import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class ShowTicketsUseCase {
  final HomeEduRepository repository;

  ShowTicketsUseCase({required this.repository});

  Future<ShowTicketsResponse> call({required ShowTicketsParams params}) {
    return repository.getTickets(params: params);
  }
}
