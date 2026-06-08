import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/antiplagiat_file/add_antiplagiat_file_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/antiplagiat_file/antiplagiat_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class AntiplagiatFileBloc extends Bloc<ArticlesHomeEvent, AntiplagiatFileState> {
  final AddAntiplagiatFileUseCase useCase;

  AntiplagiatFileBloc({required this.useCase}) : super(AntiplagiatFileInitial()) {
    on<AntiplagiatFileEvent>((event, emit) async {
      emit(AntiplagiatFileLoading());
      try {
        await useCase.call(params: event.params);
        emit(AntiplagiatFileLoaded());
      } catch (e) {
        emit(AntiplagiatFileError());
      }
    });
  }
}
