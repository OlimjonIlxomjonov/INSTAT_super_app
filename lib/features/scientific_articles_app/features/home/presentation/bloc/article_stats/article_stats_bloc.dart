import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/articles_stats/articles_stats_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/article_stats/article_stats_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticleStatsBloc extends Bloc<ArticlesHomeEvent, ArticleStatsState> {
  final ArticlesStatsUseCase useCase;

  ArticleStatsBloc({required this.useCase}) : super(ArticleStatsInitial()) {
    on<ArticleStatsEvent>((event, emit) async {
      emit(ArticleStatsLoading());
      try {
        final entity = await useCase.call(countType: event.countType);
        emit(ArticleStatsLoaded(entity: entity));
      } catch (e) {
        emit(ArticleStatsError());
      }
    });
  }
}
