import 'package:equatable/equatable.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';

class SearchBooksEvent extends Equatable {
  final SearchBooksParams params;

  const SearchBooksEvent({required this.params});

  @override
  List<Object?> get props => [params];
}