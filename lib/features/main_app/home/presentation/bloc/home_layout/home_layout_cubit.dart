import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/layout/home_layout_prefs_service.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_layout/home_layout_state.dart';

/// Bosh sahifa bo'limlarining tartibini saqlaydi.
/// Drawer'dagi sozlama ham, home tagidagi tugma ham shu bitta manbaga yozadi.
class HomeLayoutCubit extends Cubit<HomeLayoutState> {
  HomeLayoutCubit()
    : super(
        HomeLayoutState(
          order: HomeLayoutPrefsService.loadOrder(),
          hidden: HomeLayoutPrefsService.loadHidden(),
        ),
      );

  void reorder(int oldIndex, int newIndex) {
    final order = List<HomeSectionId>.from(state.order);
    final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
    order.insert(target, order.removeAt(oldIndex));
    _apply(state.copyWith(order: order));
  }

  void toggleVisibility(HomeSectionId id) {
    final hidden = Set<HomeSectionId>.from(state.hidden);
    hidden.contains(id) ? hidden.remove(id) : hidden.add(id);
    _apply(state.copyWith(hidden: hidden));
  }

  void resetToDefault() {
    HomeLayoutPrefsService.reset();
    emit(HomeLayoutState(order: HomeSectionId.values, hidden: const {}));
  }

  void _apply(HomeLayoutState next) {
    emit(next);
    HomeLayoutPrefsService.save(order: next.order, hidden: next.hidden);
  }
}
