import 'package:equatable/equatable.dart';
import 'package:my_template/features/main_app/home/domain/entity/site_faqs/site_faqs_entity.dart';

class SiteFaqsState extends Equatable {
  const SiteFaqsState();

  @override
  List<Object?> get props => [];
}

class SiteFaqsInitial extends SiteFaqsState {}

class SiteFaqsLoading extends SiteFaqsState {}

class SiteFaqsLoaded extends SiteFaqsState {
  final List<SiteFaqsEntity> listEntity;

  const SiteFaqsLoaded({required this.listEntity});

  @override
  List<Object?> get props => [listEntity];
}

class SiteFaqsError extends SiteFaqsState {}
