import 'package:equatable/equatable.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/library_stats/library_stats_entity.dart';

class LibraryStatsState extends Equatable {
  const LibraryStatsState();

  @override
  List<Object?> get props => [];
}

class LibraryStatsInitial extends LibraryStatsState {}

class LibraryStatsLoading extends LibraryStatsState {}

class LibraryStatsLoaded extends LibraryStatsState {
  final LibraryStatsEntity entity;

  const LibraryStatsLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class LibraryStatsError extends LibraryStatsState {}
