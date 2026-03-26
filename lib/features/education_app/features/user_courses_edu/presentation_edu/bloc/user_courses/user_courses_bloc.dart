import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course/courses_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses/user_courses_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class UserCoursesBloc extends Bloc<CoursesEvent, UserCoursesState> {
  final CoursesUseCase useCase;

  UserCoursesBloc(this.useCase) : super(UserCoursesInitial()) {
    on<UserCoursesEvent>((event, emit) async {
      emit(UserCoursesLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(UserCoursesLoaded(response: response));
      } catch (e) {
        emit(UserCoursesError());
      }
    });
  }
}
