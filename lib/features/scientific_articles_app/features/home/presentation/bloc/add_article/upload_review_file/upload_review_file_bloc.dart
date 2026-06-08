import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/review_file/add_review_file_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/upload_review_file/upload_review_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class UploadReviewFileBloc extends Bloc<ArticlesHomeEvent, UploadReviewFileState> {
  final AddReviewFileUseCase useCase;

  UploadReviewFileBloc({required this.useCase})
    : super(UploadReviewFileInitial()) {
    on<UploadReviewFileEvent>((event, emit) async {
      emit(UploadReviewFileLoading(type: event.params.type));
      try {
        final entity = await useCase.call(params: event.params);
        emit(UploadReviewFileLoaded(entity: entity));
      } catch (e) {
        emit(UploadReviewFileError(type: event.params.type));
      }
    });
  }
}
