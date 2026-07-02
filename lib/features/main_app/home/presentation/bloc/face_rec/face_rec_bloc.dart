import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/face_rec/face_rec_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class FaceRecBloc extends Bloc<HomeEvent, FaceRecState> {
  final FaceRecUseCase useCase;

  FaceRecBloc({required this.useCase}) : super(FaceRecInitial()) {
    on<FaceRecEvent>((event, emit) async {
      emit(FaceRecLoading());
      try {
        await useCase.call(params: event.params);
        emit(FaceRecLoaded());
      } catch (e) {
        emit(FaceRecError());
      }
    });
  }
}
