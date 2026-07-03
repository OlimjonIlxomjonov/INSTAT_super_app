import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/face_rec/face_rec_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/face_rec/get_my_id_session_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/face_rec/face_rec_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class MyIdSessionCache {
  final String sessionId;
  final String birthDate;
  final String passportData;
  final DateTime createdAt;

  MyIdSessionCache({
    required this.sessionId,
    required this.birthDate,
    required this.passportData,
    required this.createdAt,
  });

  bool isValid(String birthDate, String passportData) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inMinutes < 5 &&
        this.birthDate == birthDate &&
        this.passportData == passportData;
  }
}

class FaceRecBloc extends Bloc<HomeEvent, FaceRecState> {
  final FaceRecUseCase useCase;
  final GetMyIdSessionUseCase getSessionUseCase;
  MyIdSessionCache? _sessionCache;

  FaceRecBloc({required this.useCase, required this.getSessionUseCase})
    : super(FaceRecInitial()) {
    on<FaceRecEvent>((event, emit) async {
      emit(FaceRecLoading());
      try {
        await useCase.call(params: event.params);
        emit(FaceRecLoaded());
      } catch (e) {
        emit(FaceRecError());
      }
    });

    on<GetMyIdSessionEvent>((event, emit) async {
      // Check if we have a valid cached session ID (less than 5 minutes old & matching parameters)
      if (_sessionCache != null &&
          _sessionCache!.isValid(event.birthDate, event.passportData)) {
        emit(FaceRecSessionLoaded(sessionId: _sessionCache!.sessionId));
        return;
      }

      emit(FaceRecSessionLoading());
      try {
        final sessionId = await getSessionUseCase.call(
          birthDate: event.birthDate,
          passportData: event.passportData,
        );
        _sessionCache = MyIdSessionCache(
          sessionId: sessionId,
          birthDate: event.birthDate,
          passportData: event.passportData,
          createdAt: DateTime.now(),
        );
        emit(FaceRecSessionLoaded(sessionId: sessionId));
      } catch (e) {
        emit(FaceRecSessionError(message: e.toString()));
      }
    });

    on<ResetFaceRecEvent>((event, emit) {
      emit(FaceRecInitial());
    });
  }
}
