import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/per_course/per_course_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/per_course/per_course_state.dart';

class PerCourseBloc extends Bloc<HomeEduEvent, PerCourseState> {
  final PerCourseUseCase useCase;

  PerCourseBloc({required this.useCase}) : super(PerCourseInitial()) {
    on<PerCourseEvent>((event, emit) async {
      emit(PerCourseLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(PerCourseLoaded(entity: entity));
      } catch (e) {
        emit(PerCourseError());
      }
    });
  }
}
