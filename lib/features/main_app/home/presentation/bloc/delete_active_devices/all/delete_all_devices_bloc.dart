import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/delete_devices/all_devices/delete_all_devices_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/delete_active_devices/all/delete_all_devices_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class DeleteAllDevicesBloc extends Bloc<HomeEvent, DeleteAllDevicesState> {
  final DeleteAllDevicesUseCase useCase;

  DeleteAllDevicesBloc({required this.useCase})
    : super(DeleteAllDevicesInitial()) {
    on<DeleteActiveDevicesEvent>((event, emit) async {
      emit(DeleteAllDevicesLoading());
      try {
        await useCase.call();
        emit(DeleteAllDevicesLoaded());
      } catch (e) {
        emit(DeleteAllDevicesError());
      }
    });
  }
}
