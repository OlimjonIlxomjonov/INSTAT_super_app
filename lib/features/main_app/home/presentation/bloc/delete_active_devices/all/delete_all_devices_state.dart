import 'package:equatable/equatable.dart';

class DeleteAllDevicesState {
  const DeleteAllDevicesState();
}

class DeleteAllDevicesInitial extends DeleteAllDevicesState {}

class DeleteAllDevicesLoading extends DeleteAllDevicesState {}

class DeleteAllDevicesLoaded extends DeleteAllDevicesState {}

class DeleteAllDevicesError extends DeleteAllDevicesState {}
