import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/offline_lessons/offline_lessons_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_lessons/offline_lessons_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class OfflineLessonsBloc extends Bloc<CoursesEvent, OfflineLessonsState> {
  final OfflineLessonsUseCase useCase;

  OfflineLessonsBloc({required this.useCase}) : super(OfflineLessonsInitial()) {
    on<OfflineLessonsEvent>((event, emit) async {
      emit(OfflineLessonsLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(OfflineLessonsLoaded(entity: entity));
      } catch (e) {
        emit(OfflineLessonsError());
      }
    });
  }
}
