import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/about_course_features/about_course_features_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_course_features_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class AboutCourseFeaturesBloc
    extends Bloc<CoursesEvent, AboutCourseFeaturesState> {
  final AboutCourseFeaturesUseCase useCase;

  AboutCourseFeaturesBloc(this.useCase) : super(AboutCourseFeaturesInitial()) {
    on<AboutCourseFeaturesEvent>((event, emit) async {
      emit(AboutCourseFeaturesLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(AboutCourseFeaturesLoaded(response: response));
      } catch (e) {
        emit(AboutCourseFeaturesError());
      }
    });
  }
}
