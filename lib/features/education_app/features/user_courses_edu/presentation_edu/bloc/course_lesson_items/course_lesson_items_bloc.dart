import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_items/lessons_items_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CourseLessonItemsBloc
    extends Bloc<CoursesEvent, CourseLessonItemsState> {
  final LessonsItemsUseCase useCase;

  CourseLessonItemsBloc(this.useCase) : super(const CourseLessonItemsState()) {
    on<ResetCourseLessonItemsEvent>((event, emit) {
      emit(const CourseLessonItemsState());
    });

    on<CourseLessonItemsEvent>((event, emit) async {
      final blockId = event.params.blockId;

      // Mark as loading
      emit(state.copyWith(
        loadingBlocks: {...state.loadingBlocks, blockId},
        errorBlocks: {...state.errorBlocks}..remove(blockId),
      ));

      try {
        final response = await useCase.call(params: event.params);

        // Mark as loaded
        emit(state.copyWith(
          loadingBlocks: {...state.loadingBlocks}..remove(blockId),
          loadedBlocks: {...state.loadedBlocks, blockId: response},
        ));
      } catch (e) {
        // Mark as error
        emit(state.copyWith(
          loadingBlocks: {...state.loadingBlocks}..remove(blockId),
          errorBlocks: {...state.errorBlocks, blockId: e.toString()},
        ));
      }
    });
  }
}
