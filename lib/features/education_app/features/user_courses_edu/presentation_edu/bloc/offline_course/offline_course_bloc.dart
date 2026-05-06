import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/offline_course/offline_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_course/offline_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class OfflineCourseBloc extends Bloc<CoursesEvent, OfflineCourseState> {
  final OfflineCourseUseCase useCase;

  OfflineCourseBloc({required this.useCase}) : super(OfflineCourseInitial()) {
    on<OfflineCourseEvent>((event, emit) async {
      emit(OfflineCourseLoading());
      try {
        final response = await useCase.call();
        emit(OfflineCourseLoaded(response: response));
      } catch (e) {
        emit(OfflineCourseError());
      }
    });
  }
}
