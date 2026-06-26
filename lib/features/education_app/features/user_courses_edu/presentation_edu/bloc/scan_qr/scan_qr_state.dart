import 'package:equatable/equatable.dart';

class ScanQrState extends Equatable {
  const ScanQrState();

  @override
  List<Object?> get props => [];
}

class ScanQrInitial extends ScanQrState {}

class ScanQrLoading extends ScanQrState {}

class ScanQrLoaded extends ScanQrState {}

class ScanQrError extends ScanQrState {}
