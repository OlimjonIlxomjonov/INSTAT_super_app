import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_entity.dart';

class LessonNeighbors {
  final CourseLessonItemsEntity? previous;
  final CourseLessonItemsEntity? next;
  final bool isPreviousPending;
  final bool isNextPending;
  final Set<int> blocksToLoad;

  const LessonNeighbors({
    this.previous,
    this.next,
    this.isPreviousPending = false,
    this.isNextPending = false,
    this.blocksToLoad = const {},
  });
}

LessonNeighbors resolveLessonNeighbors({
  required List<int> blockIds,
  required Map<int, List<CourseLessonItemsEntity>> lessonsByBlock,
  required int blockId,
  required int lessonId,
}) {
  final lessons = lessonsByBlock[blockId];
  if (lessons == null) {
    return LessonNeighbors(
      isPreviousPending: true,
      isNextPending: true,
      blocksToLoad: {blockId},
    );
  }

  final index = lessons.indexWhere((lesson) => lesson.id == lessonId);
  if (index < 0) return const LessonNeighbors();

  final toLoad = <int>{};
  final blockIndex = blockIds.indexOf(blockId);

  CourseLessonItemsEntity? previous;
  var isPreviousPending = false;
  if (index > 0) {
    previous = lessons[index - 1];
  } else if (blockIndex > 0) {
    for (var i = blockIndex - 1; i >= 0; i--) {
      final loaded = lessonsByBlock[blockIds[i]];
      if (loaded == null) {
        toLoad.add(blockIds[i]);
        isPreviousPending = true;
        break;
      }
      if (loaded.isNotEmpty) {
        previous = loaded.last;
        break;
      }
    }
  }

  CourseLessonItemsEntity? next;
  var isNextPending = false;
  if (index < lessons.length - 1) {
    next = lessons[index + 1];
  } else if (blockIndex >= 0) {
    for (var i = blockIndex + 1; i < blockIds.length; i++) {
      final loaded = lessonsByBlock[blockIds[i]];
      if (loaded == null) {
        toLoad.add(blockIds[i]);
        isNextPending = true;
        break;
      }
      if (loaded.isNotEmpty) {
        next = loaded.first;
        break;
      }
    }
  }

  return LessonNeighbors(
    previous: previous,
    next: next,
    isPreviousPending: isPreviousPending,
    isNextPending: isNextPending,
    blocksToLoad: toLoad,
  );
}
