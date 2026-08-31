import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_variables/report_variables_entity.dart';

class ReportVariablesState extends Equatable {
  const ReportVariablesState();

  @override
  List<Object?> get props => [];
}

class ReportVariablesInitial extends ReportVariablesState {}

class ReportVariablesLoading extends ReportVariablesState {}

class ReportVariablesLoaded extends ReportVariablesState {
  final List<ReportVariablesEntity> listEntity;

  const ReportVariablesLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class ReportVariablesError extends ReportVariablesState {}
