import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/edition_articles/edition_articles_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/edition_articles/edition_articles_state.dart';

class EditionArticlesBloc
    extends Bloc<ArticlesHomeEvent, EditionArticlesState> {
  final EditionArticlesUseCase useCase;

  EditionArticlesBloc({required this.useCase})
    : super(EditionArticlesInitial()) {
    on<EditionArticlesEvent>((event, emit) async {
      emit(EditionArticlesLoading());
      try {
        final items = await useCase.call(editionId: event.editionId);
        emit(EditionArticlesLoaded(items: items));
      } catch (e) {
        emit(EditionArticlesError());
      }
    });
  }
}
