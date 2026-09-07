import 'package:equatable/equatable.dart';

abstract class OfflineBooksEvent extends Equatable {
  const OfflineBooksEvent();

  @override
  List<Object?> get props => [];
}

class FetchOfflineBooks extends OfflineBooksEvent {
  final String search;
  final int page;
  final int? categoryId;

  const FetchOfflineBooks({this.search = '', this.page = 1, this.categoryId});

  @override
  List<Object?> get props => [search, page, categoryId];
}
