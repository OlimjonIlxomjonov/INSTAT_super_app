import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/about_course_features/about_course_features_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_course_features_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';

class AboutCourseFeaturesBloc
    extends Bloc<CoursesEvent, AboutCourseFeaturesState> {
  final AboutCourseFeaturesUseCase useCase;
  final Map<int, AboutCourseResponse> _cache = {};
  final Set<int> _fetchingIds = {};

  AboutCourseFeaturesBloc(this.useCase) : super(AboutCourseFeaturesInitial()) {
    on<AboutCourseFeaturesEvent>((event, emit) async {
      final id = event.params.id;

      if (_cache.containsKey(id)) {
        emit(AboutCourseFeaturesLoaded(response: _cache[id]!, cachedResponses: Map.from(_cache)));
        return;
      }

      if (_fetchingIds.contains(id)) return;

      _fetchingIds.add(id);
      emit(AboutCourseFeaturesLoading(cachedResponses: Map.from(_cache)));

      try {
        final response = await useCase.call(params: event.params);
        _cache[id] = response;
        _fetchingIds.remove(id);
        emit(AboutCourseFeaturesLoaded(response: response, cachedResponses: Map.from(_cache)));
      } catch (e) {
        _fetchingIds.remove(id);
        emit(AboutCourseFeaturesError(cachedResponses: Map.from(_cache)));
      }
    });
  }
}
