import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_response_entity.dart';

class CourseLessonItemsState {
  final Map<int, CourseLessonItemsResponseEntity> loadedBlocks;
  final Set<int> loadingBlocks;
  final Map<int, String> errorBlocks;

  const CourseLessonItemsState({
    this.loadedBlocks = const {},
    this.loadingBlocks = const {},
    this.errorBlocks = const {},
  });

  CourseLessonItemsState copyWith({
    Map<int, CourseLessonItemsResponseEntity>? loadedBlocks,
    Set<int>? loadingBlocks,
    Map<int, String>? errorBlocks,
  }) {
    return CourseLessonItemsState(
      loadedBlocks: loadedBlocks ?? this.loadedBlocks,
      loadingBlocks: loadingBlocks ?? this.loadingBlocks,
      errorBlocks: errorBlocks ?? this.errorBlocks,
    );
  }
}
