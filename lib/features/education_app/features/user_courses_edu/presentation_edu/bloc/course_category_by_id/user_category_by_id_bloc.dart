import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_category/course_category_by_id_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';

class UserCategoryByIdBloc
    extends Bloc<UserCategoryByIdEvent, UserCategoryByIdState> {
  final CourseCategoryByIdUseCase useCase;
  final Map<int, CourseCategoryByIdEntity> _cache = {};
  final Set<int> _fetchingIds = {};

  UserCategoryByIdBloc(this.useCase) : super(UserCategoryByIdInitial()) {
    on<UserCategoryByIdEvent>((event, emit) async {
      final id = event.params.id;

      if (_cache.containsKey(id)) {
        emit(UserCategoryByIdLoaded(entity: _cache[id]!, categories: Map.from(_cache)));
        return;
      }

      if (_fetchingIds.contains(id)) return;

      _fetchingIds.add(id);
      emit(UserCategoryByIdLoading(categories: Map.from(_cache)));

      try {
        final entity = await useCase.call(params: event.params);
        _cache[id] = entity;
        _fetchingIds.remove(id);
        emit(UserCategoryByIdLoaded(entity: entity, categories: Map.from(_cache)));
      } catch (e) {
        _fetchingIds.remove(id);
        emit(UserCategoryByIdError(categories: Map.from(_cache)));
      }
    });
  }
}
