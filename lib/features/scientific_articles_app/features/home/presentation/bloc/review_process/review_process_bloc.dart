import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/review_process/review_process_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_process/review_process_state.dart';

class ReviewProcessBloc extends Bloc<ArticlesHomeEvent, ReviewProcessState> {
  final ReviewProcessUseCase useCase;

  ReviewProcessBloc({required this.useCase}) : super(ReviewProcessInitial()) {
    on<ReviewProcessEvent>((event, emit) async {
      emit(ReviewProcessLoading());
      try {
        final listEntity = await useCase.call();
        emit(ReviewProcessLoaded(listEntity: listEntity));
      } catch (e) {
        emit(ReviewProcessError());
      }
    });
  }
}
