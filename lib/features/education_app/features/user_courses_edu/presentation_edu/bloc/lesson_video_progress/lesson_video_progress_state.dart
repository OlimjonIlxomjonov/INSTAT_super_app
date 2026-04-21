abstract class LessonVideoProgressState {}

class LessonVideoProgressInitial extends LessonVideoProgressState {}

class LessonVideoProgressLoading extends LessonVideoProgressState {}

class LessonVideoProgressSuccess extends LessonVideoProgressState {
  final int progress;

  LessonVideoProgressSuccess({required this.progress});
}

class LessonVideoProgressFailure extends LessonVideoProgressState {
  final String message;

  LessonVideoProgressFailure(this.message);
}
