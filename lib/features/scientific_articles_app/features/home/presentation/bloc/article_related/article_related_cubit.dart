import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_related/article_related_use_cases.dart';

enum ArticleRelatedTab { byAuthor, bySection }

class ArticleRelatedSection extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ArticleBriefEntity>? items;

  const ArticleRelatedSection({this.isLoading = false, this.error, this.items});

  bool get isLoaded => items != null;

  @override
  List<Object?> get props => [isLoading, error, items];
}

class ArticleRelatedState extends Equatable {
  final ArticleRelatedTab tab;
  final ArticleRelatedSection byAuthor;
  final ArticleRelatedSection bySection;

  const ArticleRelatedState({
    this.tab = ArticleRelatedTab.byAuthor,
    this.byAuthor = const ArticleRelatedSection(),
    this.bySection = const ArticleRelatedSection(),
  });

  ArticleRelatedSection get current =>
      tab == ArticleRelatedTab.byAuthor ? byAuthor : bySection;

  ArticleRelatedState copyWith({
    ArticleRelatedTab? tab,
    ArticleRelatedSection? byAuthor,
    ArticleRelatedSection? bySection,
  }) {
    return ArticleRelatedState(
      tab: tab ?? this.tab,
      byAuthor: byAuthor ?? this.byAuthor,
      bySection: bySection ?? this.bySection,
    );
  }

  @override
  List<Object?> get props => [tab, byAuthor, bySection];
}

/// Har tab bir marta yuklanadi — qayta almashtirganda keshdan olinadi.
class ArticleRelatedCubit extends Cubit<ArticleRelatedState> {
  final ArticlesByAuthorUseCase byAuthorUseCase;
  final ArticlesBySectionUseCase bySectionUseCase;

  ArticleRelatedCubit({
    required this.byAuthorUseCase,
    required this.bySectionUseCase,
  }) : super(const ArticleRelatedState());

  Future<void> selectTab(ArticleRelatedTab tab, int reviewId) async {
    emit(state.copyWith(tab: tab));
    final section = tab == ArticleRelatedTab.byAuthor
        ? state.byAuthor
        : state.bySection;

    if (section.isLoaded || section.isLoading) return;
    await _load(tab, reviewId);
  }

  Future<void> reload(int reviewId) => _load(state.tab, reviewId);

  Future<void> refreshAll(int reviewId) async {
    emit(const ArticleRelatedState().copyWith(tab: state.tab));
    await _load(state.tab, reviewId);
  }

  Future<void> _load(ArticleRelatedTab tab, int reviewId) async {
    _emitSection(tab, const ArticleRelatedSection(isLoading: true));

    try {
      final items = tab == ArticleRelatedTab.byAuthor
          ? await byAuthorUseCase(reviewId)
          : await bySectionUseCase(reviewId);
      if (isClosed) return;
      _emitSection(tab, ArticleRelatedSection(items: items));
    } catch (e) {
      if (isClosed) return;
      _emitSection(tab, ArticleRelatedSection(error: apiErrorMessage(e) ?? ''));
    }
  }

  void _emitSection(ArticleRelatedTab tab, ArticleRelatedSection section) {
    emit(
      tab == ArticleRelatedTab.byAuthor
          ? state.copyWith(byAuthor: section)
          : state.copyWith(bySection: section),
    );
  }
}
