import 'package:equatable/equatable.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';

class AddCommentEvent extends Equatable {
  final AddCommentParams params;

  const AddCommentEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
