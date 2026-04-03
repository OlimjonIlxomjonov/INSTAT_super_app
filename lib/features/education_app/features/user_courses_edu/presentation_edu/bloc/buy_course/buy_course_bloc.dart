import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/buy_course/buy_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class BuyCourseBloc extends Bloc<CoursesEvent, BuyCourseState> {
  final BuyCourseUseCase useCase;

  BuyCourseBloc({required this.useCase}) : super(BuyCourseInitial()) {
    on<BuyCourseEvent>((event, emit) async {
      emit(BuyCourseLoading());
      try {
        await useCase.call(params: event.params);
        emit(BuyCourseLoaded());
      } catch (e) {
        emit(BuyCourseError());
      }
    });
  }
}
