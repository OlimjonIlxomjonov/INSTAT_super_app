import 'package:equatable/equatable.dart';
import 'package:my_template/features/mikro_data/domain/entity/report_files/report_files_entity.dart';

class ReportFilesState extends Equatable {
  const ReportFilesState();

  @override
  List<Object?> get props => [];
}

class ReportFilesInitial extends ReportFilesState {}

class ReportFilesLoading extends ReportFilesState {}

class ReportFilesLoaded extends ReportFilesState {
  final List<ReportFilesEntity> listEntity;

  const ReportFilesLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class ReportFilesError extends ReportFilesState {}
