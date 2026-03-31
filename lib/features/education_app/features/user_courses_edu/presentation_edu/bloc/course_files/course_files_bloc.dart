import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_files/course_files_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CourseFilesBloc extends Bloc<CoursesEvent, CourseFilesState> {
  final CourseFilesUseCase useCase;

  CourseFilesBloc(this.useCase) : super(CourseFilesInitial()) {
    on<CourseFilesEvent>((event, emit) async {
      emit(CourseFilesLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(CourseFilesLoaded(entity: entity));
      } catch (e) {
        emit(CourseFilesError());
      }
    });
  }
}
