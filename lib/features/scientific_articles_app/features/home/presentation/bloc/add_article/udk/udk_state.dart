import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/udk/udk_entity.dart';

class UdkState extends Equatable {
  const UdkState();

  @override
  List<Object?> get props => [];
}

class UdkInitial extends UdkState {}

class UdkLoading extends UdkState {}

class UdkLoaded extends UdkState {
  final UdkEntity entity;

  const UdkLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class UdkError extends UdkState {}
