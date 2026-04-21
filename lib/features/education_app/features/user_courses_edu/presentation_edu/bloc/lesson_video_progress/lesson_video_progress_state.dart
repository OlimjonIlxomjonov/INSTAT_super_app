abstract class LessonVideoProgressState {}

class LessonVideoProgressInitial extends LessonVideoProgressState {}

class LessonVideoProgressLoading extends LessonVideoProgressState {}

class LessonVideoProgressSuccess extends LessonVideoProgressState {}

class LessonVideoProgressFailure extends LessonVideoProgressState {
  final String message;

  LessonVideoProgressFailure(this.message);
}
