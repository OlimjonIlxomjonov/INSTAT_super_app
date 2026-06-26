import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/scan_qr/scan_qr_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/scan_qr/scan_qr_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class ScanQrBloc extends Bloc<CoursesEvent, ScanQrState> {
  final ScanQrUseCase useCase;

  ScanQrBloc(this.useCase) : super(ScanQrInitial()) {
    on<ScanQrEvent>((event, emit) async {
      emit(ScanQrLoading());
      try {
        await useCase.call(params: event.params);
        emit(ScanQrLoaded());
      } catch (e) {
        emit(ScanQrError());
      }
    });
  }
}
