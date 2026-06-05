import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/main_file/add_main_file_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class MainFileBloc extends Bloc<ArticlesHomeEvent, MainFileState> {
  final AddMainFileUseCase useCase;

  MainFileBloc({required this.useCase}) : super(MainFileInitial()) {
    on<MainFileArticleEvent>((event, emit) async {
      emit(MainFileLoading());
      try {
        await useCase.call(params: event.params);
        emit(MainFileLoaded());
      } catch (e) {
        emit(MainFileError());
      }
    });
  }
}
