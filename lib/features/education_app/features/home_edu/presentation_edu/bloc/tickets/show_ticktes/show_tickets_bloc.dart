import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/tickets/show_tickets/show_tickets_use_case.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/show_ticktes/show_tickets_state.dart';

class ShowTicketsBloc extends Bloc<HomeEduEvent, ShowTicketsState> {
  final ShowTicketsUseCase useCase;

  ShowTicketsBloc({required this.useCase}) : super(ShowTicketsInitial()) {
    on<ShowTicketsEvent>((event, emit) async {
      // emit(ShowTicketsLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(ShowTicketsLoaded(response: response));
      } catch (e) {
        emit(ShowTicketsError());
      }
    });
  }
}
