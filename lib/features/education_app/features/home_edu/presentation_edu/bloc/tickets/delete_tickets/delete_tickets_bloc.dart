import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/tickets/delete_ticket/delete_ticket_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/delete_tickets/delete_tickets_state.dart';

class DeleteTicketsBloc extends Bloc<HomeEduEvent, DeleteTicketsState> {
  final DeleteTicketUseCase useCase;

  DeleteTicketsBloc({required this.useCase}) : super(DeleteTicketsInitial()) {
    on<DeleteTicketEvent>((event, emit) async {
      emit(DeleteTicketsLoading());
      try {
        await useCase.call(params: event.params);
        emit(DeleteTicketsLoaded());
      } catch (e) {
        emit(DeleteTicketsError());
      }
    });
  }
}
