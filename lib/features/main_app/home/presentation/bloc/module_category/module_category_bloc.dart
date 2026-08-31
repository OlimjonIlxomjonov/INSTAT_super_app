import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/module_category/module_category_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/module_category/module_category_state.dart';

class ModuleCategoryBloc extends Bloc<HomeEvent, ModuleCategoryState> {
  final ModuleCategoryUseCase useCase;

  ModuleCategoryBloc({required this.useCase}) : super(ModuleCategoryInitial()) {
    on(onModuleCategory);
  }

  Future<void> onModuleCategory(
    ModuleCategoryEvent event,
    Emitter<ModuleCategoryState> emit,
  ) async {
    emit(ModuleCategoryLoading());
    try {
      final response = await useCase.call(params: event.params);
      emit(ModuleCategoryLoaded(response: response));
    } catch (e) {
      emit(ModuleCategoryError());
    }
  }
}
