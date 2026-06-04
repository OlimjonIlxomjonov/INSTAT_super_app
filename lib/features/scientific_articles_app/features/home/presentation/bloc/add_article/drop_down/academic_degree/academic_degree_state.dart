import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class AcademicDegreeState extends Equatable {
  const AcademicDegreeState();

  @override
  List<Object?> get props => [];
}

class AcademicDegreeInitial extends AcademicDegreeState {}

class AcademicDegreeLoading extends AcademicDegreeState {}

class AcademicDegreeLoaded extends AcademicDegreeState {
  final List<DropDownEntity> entity;

  const AcademicDegreeLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class AcademicDegreeError extends AcademicDegreeState {}
