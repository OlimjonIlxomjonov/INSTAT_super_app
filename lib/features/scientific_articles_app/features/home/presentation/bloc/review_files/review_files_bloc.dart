import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_file/review_file_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_state.dart';

class ReviewFilesBloc extends Bloc<ArticlesHomeEvent, ReviewFilesState> {
  final ReviewFileUseCase useCase;

  ReviewFilesBloc({required this.useCase}) : super(ReviewFilesInitial()) {
    on<ReviewFilesEvent>((event, emit) async {
      emit(ReviewFilesLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(ReviewFilesLoaded(entity: entity));
      } catch (e) {
        emit(ReviewFilesError());
      }
    });
  }
}
