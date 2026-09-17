import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/delete_devices/by_id/delete_device_by_id_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/delete_active_devices/by_id/delete_device_by_id_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class DeleteDeviceByIdBloc extends Bloc<HomeEvent, DeleteDeviceByIdState> {
  final DeleteDeviceByIdUseCase useCase;

  DeleteDeviceByIdBloc({required this.useCase})
    : super(DeleteDeviceByIdInitial()) {
    on<DeleteDeviceByIdEvent>((event, emit) async {
      emit(DeleteDeviceByIdLoading());
      try {
        await useCase.call(event.id);
        emit(DeleteDeviceByIdLoaded());
      } catch (e) {
        emit(DeleteDeviceByIdError());
      }
    });
  }
}
