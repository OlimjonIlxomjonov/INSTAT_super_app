import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/avatar/avatar_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/avatar/avatar_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class AvatarBloc extends Bloc<HomeEvent, AvatarState> {
  final AvatarUseCase useCase;

  AvatarBloc({required this.useCase}) : super(AvatarInitial()) {
    on<AvatarEvent>((event, emit) async {
      emit(AvatarLoading());
      try {
        await useCase.call(params: event.params);
        emit(AvatarLoaded());
      } catch (e) {
        emit(AvatarError());
      }
    });
  }
}
