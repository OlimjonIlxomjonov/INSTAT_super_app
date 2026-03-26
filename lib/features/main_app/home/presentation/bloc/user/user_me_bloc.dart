import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/user_me/user_me_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';

class UserMeBloc extends Bloc<HomeEvent, UserMeState> {
  final UserMeUseCase useCase;

  UserMeBloc(this.useCase) : super(UserMeInitial()) {
    on<UserMeEvent>((event, emit) async {
      emit(UserMeLoading());
      try {
        final entity = await useCase.call();
        emit(UserMeLoaded(entity: entity));
      } catch (e) {
        emit(UserMeError());
      }
    });
  }
}
