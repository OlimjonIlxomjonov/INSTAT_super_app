import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lessons_topics/lessons_topics_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CourseLessonTopicsBloc
    extends Bloc<CoursesEvent, CourseLessonTopicsState> {
  final LessonsTopicsUseCase useCase;

  CourseLessonTopicsBloc(this.useCase) : super(CourseLessonTopicsInitial()) {
    on<CourseLessonTopicsEvent>((event, emit) async {
      emit(CourseLessonTopicsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(CourseLessonTopicsLoaded(response: response));
      } catch (e) {
        emit(CourseLessonTopicsError());
      }
    });
  }
}
