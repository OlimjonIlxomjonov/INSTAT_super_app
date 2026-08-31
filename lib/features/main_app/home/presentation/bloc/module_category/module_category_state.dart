import 'package:equatable/equatable.dart';
import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_response.dart';

class ModuleCategoryState extends Equatable {
  const ModuleCategoryState();

  @override
  List<Object?> get props => [];
}

class ModuleCategoryInitial extends ModuleCategoryState {}

class ModuleCategoryLoading extends ModuleCategoryState {}

class ModuleCategoryLoaded extends ModuleCategoryState {
  final ModuleCategoryResponse response;

  const ModuleCategoryLoaded({required this.response});
}

class ModuleCategoryError extends ModuleCategoryState {}
