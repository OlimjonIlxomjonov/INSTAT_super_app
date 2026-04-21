import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_video_progress/put_lesson_video_progress_use_case.dart';

import 'lesson_video_progress_event.dart';
import 'lesson_video_progress_state.dart';

class LessonVideoProgressBloc extends Bloc<LessonVideoProgressEvent, LessonVideoProgressState> {
  final PutLessonVideoProgressUseCase _putLessonVideoProgressUseCase;

  LessonVideoProgressBloc({
    required PutLessonVideoProgressUseCase putLessonVideoProgressUseCase,
  })  : _putLessonVideoProgressUseCase = putLessonVideoProgressUseCase,
        super(LessonVideoProgressInitial()) {
    on<PutLessonVideoProgressEvent>(_onPutLessonVideoProgressEvent);
  }

  Future<void> _onPutLessonVideoProgressEvent(
    PutLessonVideoProgressEvent event,
    Emitter<LessonVideoProgressState> emit,
  ) async {
    emit(LessonVideoProgressLoading());
    try {
      await _putLessonVideoProgressUseCase(
        LessonVideoProgressParams(
          lessonId: event.lessonId,
          progress: event.progress,
        ),
      );
      emit(LessonVideoProgressSuccess(progress: event.progress));
    } catch (e) {
      emit(LessonVideoProgressFailure(e.toString()));
    }
  }
}
