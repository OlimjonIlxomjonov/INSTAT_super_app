import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/comments/comments_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/comments/comments_state.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsUseCase useCase;

  CommentsBloc({required this.useCase}) : super(CommentsInitial()) {
    on<CommentsEvent>((event, emit) async {
      emit(CommentsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(CommentsLoaded(response: response));
      } catch (e) {
        emit(CommentsError());
      }
    });
  }
}
