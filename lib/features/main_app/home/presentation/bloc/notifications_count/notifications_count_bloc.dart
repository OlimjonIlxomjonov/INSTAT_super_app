import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/notifications_count/notifications_count_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications_count/notifications_count_state.dart';

class NotifCountBloc extends Bloc<HomeEvent, NotifCountState> {
  final NotificationsCountUseCase useCase;

  NotifCountBloc({required this.useCase}) : super(NotifCountInitial()) {
    on<NotificationsCountEvent>((event, emit) async {
      emit(NotifCountLoading());
      try {
        final entity = await useCase.call();
        emit(NotifCountLoaded(entity: entity));
      } catch (e) {
        emit(NotifCountError());
      }
    });
  }
}
