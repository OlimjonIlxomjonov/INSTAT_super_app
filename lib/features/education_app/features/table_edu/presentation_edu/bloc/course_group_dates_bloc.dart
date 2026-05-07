import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/usecase/get_course_group_dates_use_case.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_event.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_state.dart';

class CourseGroupDatesBloc
    extends Bloc<CourseGroupDatesEvent, CourseGroupDatesState> {
  final GetCourseGroupDatesUseCase _useCase;

  CourseGroupDatesBloc({required GetCourseGroupDatesUseCase useCase})
    : _useCase = useCase,
      super(CourseGroupDatesInitial()) {
    on<FetchCourseGroupDatesEvent>((event, emit) async {
      emit(CourseGroupDatesLoading());
      try {
        final dates = await _useCase(params: event.params);
        emit(CourseGroupDatesLoaded(dates: dates));
      } catch (e) {
        emit(CourseGroupDatesError(message: e.toString()));
      }
    });
  }
}
