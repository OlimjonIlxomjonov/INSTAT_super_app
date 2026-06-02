import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/drop_down/journal_section_dd_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_sections_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class JournalSectionBloc extends Bloc<ArticlesHomeEvent, JournalSectionsState> {
  final JournalSectionDdUseCase useCase;

  JournalSectionBloc({required this.useCase})
    : super(JournalSectionsInitial()) {
    on<JournalSectionsEvent>((event, emit) async {
      emit(JournalSectionsLoading());
      try {
        final entity = await useCase.call();
        emit(JournalSectionsLoaded(entity: entity));
      } catch (e) {
        emit(JournalSectionsError());
      }
    });
  }
}
