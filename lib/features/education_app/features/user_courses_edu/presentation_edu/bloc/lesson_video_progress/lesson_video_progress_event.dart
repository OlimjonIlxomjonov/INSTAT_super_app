abstract class LessonVideoProgressEvent {}

class PutLessonVideoProgressEvent extends LessonVideoProgressEvent {
  final String lessonId;
  final int progress;

  PutLessonVideoProgressEvent({
    required this.lessonId,
    required this.progress,
  });
}
