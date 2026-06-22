import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ReportsResponse response;

  const ReportsLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ReportsError extends ReportsState {}
