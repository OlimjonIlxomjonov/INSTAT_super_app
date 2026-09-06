import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/site_faqs/site_faqs_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/site_faqs/site_faqs_state.dart';

class SiteFaqsBloc extends Bloc<HomeEvent, SiteFaqsState> {
  final SiteFaqsUseCase useCase;

  SiteFaqsBloc({required this.useCase}) : super(SiteFaqsInitial()) {
    on<SiteFaqsEvent>((event, emit) async {
      emit(SiteFaqsLoading());
      try {
        final listEntity = await useCase.call(params: event.params);
        emit(SiteFaqsLoaded(listEntity: listEntity));
      } catch (e) {
        emit(SiteFaqsError());
      }
    });
  }
}
