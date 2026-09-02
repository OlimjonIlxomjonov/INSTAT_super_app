import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/tickets/create_ticket/create_ticket_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/create_tickets/create_tickets_state.dart';

class CreateTicketsBloc extends Bloc<HomeEduEvent, CreateTicketsState> {
  final CreateTicketUseCase useCase;

  CreateTicketsBloc({required this.useCase}) : super(CreateTicketsInitial()) {
    on<CreateTicketsEvent>((event, emit) async {
      emit(CreateTicketsLoading());
      try {
        await useCase.call(params: event.params);
        emit(CreateTicketsLoaded());
      } catch (e) {
        emit(CreateTicketsError());
      }
    });
  }
}
