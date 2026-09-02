import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/tickets/send_message/send_message_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/send_message/send_message_state.dart';

class SendMessageBloc extends Bloc<HomeEduEvent, SendMessageState> {
  final SendMessageUseCase useCase;

  SendMessageBloc({required this.useCase}) : super(SendMessageInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(SendMessageLoading());
      try {
        await useCase.call(params: event.params);
        emit(SendMessageLoaded());
      } catch (e) {
        emit(SendMessageError());
      }
    });
  }
}
