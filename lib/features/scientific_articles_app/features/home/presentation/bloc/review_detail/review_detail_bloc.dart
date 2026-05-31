import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_detail/review_detail_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_detail/review_detail_state.dart';

class ReviewDetailBloc extends Bloc<ArticlesHomeEvent, ReviewDetailState> {
  final ReviewDetailUseCase useCase;

  ReviewDetailBloc({required this.useCase}) : super(ReviewDetailInitial()) {
    on<ReviewDetailEvent>((event, emit) async {
      emit(ReviewDetailLoading());
      try {
        final response = await useCase.call(event.reviewId);
        emit(ReviewDetailLoaded(response: response));
      } catch (e) {
        emit(ReviewDetailError());
      }
    });
  }
}
