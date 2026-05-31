import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';

class ReviewDetailState extends Equatable {
  const ReviewDetailState();

  @override
  List<Object?> get props => [];
}

class ReviewDetailInitial extends ReviewDetailState {}

class ReviewDetailLoading extends ReviewDetailState {}

class ReviewDetailLoaded extends ReviewDetailState {
  final ReviewDetailEntity response;

  const ReviewDetailLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class ReviewDetailError extends ReviewDetailState {}
