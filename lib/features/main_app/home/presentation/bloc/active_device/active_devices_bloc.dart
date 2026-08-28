import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/active_devices/active_devices_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/active_device/active_device_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';

class ActiveDevicesBloc extends Bloc<HomeEvent, ActiveDevicesState> {
  final ActiveDevicesUseCase useCase;

  ActiveDevicesBloc({required this.useCase}) : super(ActiveDevicesInitial()) {
    on<ActiveDevicesEvent>((event, emit) async {
      emit(ActiveDevicesLoading());
      try {
        final listEntity = await useCase.call();
        emit(ActiveDevicesLoaded(listEntity: listEntity));
      } catch (e) {
        emit(ActiveDevicesError());
      }
    });
  }
}
