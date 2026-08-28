import 'package:equatable/equatable.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';

class ActiveDevicesState extends Equatable {
  const ActiveDevicesState();

  @override
  List<Object?> get props => [];
}

class ActiveDevicesInitial extends ActiveDevicesState {}

class ActiveDevicesLoading extends ActiveDevicesState {}

class ActiveDevicesLoaded extends ActiveDevicesState {
  final List<ActiveDevicesEntity> listEntity;

  const ActiveDevicesLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class ActiveDevicesError extends ActiveDevicesState {}
