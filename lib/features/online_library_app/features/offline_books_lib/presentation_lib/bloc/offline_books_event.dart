import 'package:equatable/equatable.dart';

abstract class OfflineBooksEvent extends Equatable {
  const OfflineBooksEvent();

  @override
  List<Object?> get props => [];
}

class FetchOfflineBooks extends OfflineBooksEvent {
  final String search;
  final int page;

  const FetchOfflineBooks({this.search = '', this.page = 1});

  @override
  List<Object?> get props => [search, page];
}
