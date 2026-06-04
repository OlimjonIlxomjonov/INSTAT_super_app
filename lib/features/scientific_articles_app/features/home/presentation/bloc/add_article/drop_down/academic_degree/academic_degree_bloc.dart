import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/academic_degree_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class AcademicDegreeBloc extends Bloc<ArticlesHomeEvent, AcademicDegreeState> {
  final AcademicDegreeUseCase useCase;

  AcademicDegreeBloc({required this.useCase}) : super(AcademicDegreeInitial()) {
    on<AcademicDegreeEvent>((event, emit) async {
      emit(AcademicDegreeLoading());
      try {
        final entity = await useCase.call();
        emit(AcademicDegreeLoaded(entity: entity));
      } catch (e) {
        emit(AcademicDegreeError());
      }
    });
  }
}
