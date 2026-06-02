import 'package:equatable/equatable.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class JournalSectionsState extends Equatable {
  const JournalSectionsState();

  @override
  List<Object?> get props => [];
}

class JournalSectionsInitial extends JournalSectionsState {}

class JournalSectionsLoading extends JournalSectionsState {}

class JournalSectionsLoaded extends JournalSectionsState {
  final List<DropDownEntity> entity;

  const JournalSectionsLoaded({required this.entity});

  @override
  List<Object?> get props => [entity];
}

class JournalSectionsError extends JournalSectionsState {}
