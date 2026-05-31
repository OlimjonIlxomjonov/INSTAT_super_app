import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_authors/review_authors_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_authors/review_authors_state.dart';

class ReviewAuthorsBloc extends Bloc<ArticlesHomeEvent, ReviewAuthorsState> {
  final ReviewAuthorsUseCase useCase;

  ReviewAuthorsBloc({required this.useCase}) : super(ReviewAuthorsInitial()) {
    on<ReviewAuthorsEvent>((event, emit) async {
      emit(ReviewAuthorsLoading());
      try {
        final response = await useCase.call(event.reviewId);
        emit(ReviewAuthorsLoaded(response: response));
      } catch (e) {
        emit(ReviewAuthorsError());
      }
    });
  }
}
