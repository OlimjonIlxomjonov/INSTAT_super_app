import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/user_articles/user_articles_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/user_articles/user_articles_state.dart';

class UserArticlesBloc extends Bloc<ArticlesHomeEvent, UserArticlesState> {
  final UserArticlesUseCase useCase;

  UserArticlesBloc({required this.useCase}) : super(UserArticlesInitial()) {
    on<UserArticlesEvent>((event, emit) async {
      emit(UserArticlesLoading());
      try {
        final response = await useCase.call(status: event.status, search: event.search);
        emit(UserArticlesLoaded(response: response));
      } catch (e) {
        emit(UserArticlesError());
      }
    });
  }
}
