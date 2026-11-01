import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_brief/article_brief_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/article_related/article_related_use_cases.dart';

class ArticlesByKeywordState extends Equatable {
  final List<ArticleBriefEntity>? items;
  final int page;
  final int total;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

  const ArticlesByKeywordState({
    this.items,
    this.page = 0,
    this.total = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.error,
  });

  bool get isLoaded => items != null;

  bool get canLoadMore => isLoaded && hasMore && !isLoadingMore;

  ArticlesByKeywordState copyWith({
    List<ArticleBriefEntity>? items,
    int? page,
    int? total,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ArticlesByKeywordState(
      items: items ?? this.items,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    items,
    page,
    total,
    hasMore,
    isLoadingMore,
    error,
  ];
}

class ArticlesByKeywordCubit extends Cubit<ArticlesByKeywordState> {
  final ArticlesByKeywordUseCase useCase;

  ArticlesByKeywordCubit({required this.useCase})
    : super(const ArticlesByKeywordState());

  String _keyword = '';
  int _requestId = 0;

  Future<void> load(String keyword) async {
    _keyword = keyword;
    final request = ++_requestId;
    emit(const ArticlesByKeywordState());

    try {
      final result = await useCase(keyword: _keyword);
      if (isClosed || request != _requestId) return;
      emit(
        ArticlesByKeywordState(
          items: result.items,
          page: result.currentPage,
          total: result.total,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      if (isClosed || request != _requestId) return;
      emit(ArticlesByKeywordState(error: apiErrorMessage(e) ?? ''));
    }
  }

  Future<void> refresh() => load(_keyword);

  Future<void> loadMore() async {
    final current = state;
    if (!current.canLoadMore) return;

    final request = _requestId;
    emit(current.copyWith(isLoadingMore: true));

    try {
      final result = await useCase(keyword: _keyword, page: current.page + 1);
      if (isClosed || request != _requestId) return;
      emit(
        current.copyWith(
          items: [...current.items!, ...result.items],
          page: result.currentPage,
          total: result.total,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      if (isClosed || request != _requestId) return;
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
