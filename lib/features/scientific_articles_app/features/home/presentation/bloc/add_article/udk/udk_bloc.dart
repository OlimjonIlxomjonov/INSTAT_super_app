import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/udk/udk_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class UdkBloc extends Bloc<ArticlesHomeEvent, UdkState> {
  final UdkUseCase useCase;

  UdkBloc({required this.useCase}) : super(UdkInitial()) {
    on<UdkEvent>((event, emit) async {
      emit(UdkLoading());
      try {
        final entity = await useCase.call(params: event.params);
        emit(UdkLoaded(entity: entity));
      } catch (e) {
        emit(UdkError());
      }
    });
  }
}
