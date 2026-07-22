import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/similar_courses/similar_courses_use_caase.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/similar_courses/similar_courses_state.dart';

class SimilarCoursesBloc extends Bloc<HomeEduEvent, SimilarCoursesState> {
  final SimilarCoursesUseCase useCase;

  SimilarCoursesBloc({required this.useCase}) : super(SimilarCoursesInitial()) {
    on<SimilarCoursesEvent>((event, emit) async {
      emit(SimilarCoursesLoading());
      try {
        final listEntity = await useCase.call(params: event.params);
        emit(SimilarCoursesLoaded(listEntity: listEntity));
      } catch (e) {
        emit(SimilarCoursesError());
      }
    });
  }
}
