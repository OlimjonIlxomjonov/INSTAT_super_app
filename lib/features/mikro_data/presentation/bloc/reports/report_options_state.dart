import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_options_entity.dart';

abstract class ReportOptionsState extends Equatable {
  const ReportOptionsState();

  @override
  List<Object?> get props => [];
}

class ReportOptionsInitial extends ReportOptionsState {}

class ReportOptionsLoading extends ReportOptionsState {}

class ReportOptionsLoaded extends ReportOptionsState {
  final List<ReportsOptionsEntity> options;

  const ReportOptionsLoaded({required this.options});

  @override
  List<Object?> get props => [options];
}

class ReportOptionsError extends ReportOptionsState {
  final String message;

  const ReportOptionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
