import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/add_comment/add_comment_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/add_comment/add_comment_event.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/add_comment/add_comments_state.dart';

class AddCommentsBloc extends Bloc<AddCommentEvent, AddCommentsState> {
  final AddCommentUseCase useCase;

  AddCommentsBloc({required this.useCase}) : super(AddCommentsInitial()) {
    on<AddCommentEvent>((event, emit) async {
      emit(AddCommentsLoading());
      try {
        await useCase.call(params: event.params);
        emit(AddCommentsLoaded());
      } catch (e) {
        emit(AddCommentsError());
      }
    });
  }
}
