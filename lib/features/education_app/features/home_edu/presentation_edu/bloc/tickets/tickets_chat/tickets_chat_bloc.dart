import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/tickets/tickets_chat/tickets_chat_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/tickets_chat/tickets_chat_state.dart';

class TicketsChatBloc extends Bloc<HomeEduEvent, TicketsChatState> {
  final TicketsChatUseCase useCase;

  TicketsChatBloc({required this.useCase}) : super(TicketsChatInitial()) {
    on<TicketsChatEvent>((event, emit) async {
      // emit(TicketsChatLoading());
      try {
        final listEntity = await useCase.call(params: event.params);
        emit(TicketsChatLoaded(listEntity: listEntity));
      } catch (e) {
        emit(TicketsChatError());
      }
    });
  }
}
