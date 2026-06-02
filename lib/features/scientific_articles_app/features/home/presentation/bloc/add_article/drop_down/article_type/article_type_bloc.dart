import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/article_type_dd_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticleTypeBloc extends Bloc<ArticlesHomeEvent, ArticleTypeState> {
  final ArticleTypeDdUseCase useCase;

  ArticleTypeBloc({required this.useCase}) : super(ArticleTypeInitial()) {
    on<ArticleTypeEvent>((event, emit) async {
      emit(ArticleTypeLoading());
      try {
        final entity = await useCase.call();
        emit(ArticleTypeLoaded(entity: entity));
      } catch (e) {
        emit(ArticleTypeError());
      }
    });
  }
}
