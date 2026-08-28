import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/notifications/notif_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_state.dart';

class NotifBloc extends Bloc<HomeEvent, NotifState> {
  final NotifUseCase useCase;

  NotifBloc({required this.useCase}) : super(NotifInitial()) {
    on<NotifEvent>((event, emit) async {
      emit(NotifLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(NotifLoaded(response: response));
      } catch (e) {
        emit(NotifError());
      }
    });
  }
}
