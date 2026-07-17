import 'package:equatable/equatable.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';

class BookCommentsEvent extends Equatable {
  final OnlineBookCommentsParams params;

  const BookCommentsEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
