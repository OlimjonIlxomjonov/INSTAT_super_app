import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class TicketsChatUseCase {
  final HomeEduRepository repository;

  TicketsChatUseCase({required this.repository});

  Future<List<TicketsChatEntity>> call({required TicketsChatParams params}) {
    return repository.getTicketsChat(params: params);
  }
}
