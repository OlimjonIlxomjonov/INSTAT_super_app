import 'package:equatable/equatable.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';

class HomeLayoutState extends Equatable {
  final List<HomeSectionId> order;
  final Set<HomeSectionId> hidden;

  const HomeLayoutState({required this.order, required this.hidden});

  /// KO'RINADIGANLARI
  List<HomeSectionId> get visibleOrder =>
      order.where((id) => !hidden.contains(id)).toList();

  bool isVisible(HomeSectionId id) => !hidden.contains(id);

  HomeLayoutState copyWith({
    List<HomeSectionId>? order,
    Set<HomeSectionId>? hidden,
  }) {
    return HomeLayoutState(
      order: order ?? this.order,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  List<Object?> get props => [order, hidden];
}
