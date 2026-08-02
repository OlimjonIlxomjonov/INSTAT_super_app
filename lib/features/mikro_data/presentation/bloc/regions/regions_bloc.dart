import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class RegionsState extends Equatable {
  const RegionsState();

  @override
  List<Object?> get props => [];
}

class RegionsInitial extends RegionsState {}

class RegionsLoading extends RegionsState {}

class RegionsLoaded extends RegionsState {
  final List<RegionEntity> items;

  const RegionsLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class RegionsError extends RegionsState {}

class RegionsBloc extends Bloc<MicroDataEvent, RegionsState> {
  final RegionsUseCase useCase;

  RegionsBloc({required this.useCase}) : super(RegionsInitial()) {
    on<RegionsEvent>((event, emit) async {
      // Javob ~40 KB va o'zgarmaydi — bir marta yuklangach qayta so'ramaymiz.
      // Xato holatida qayta urinish ochiq qoladi.
      if (state is RegionsLoaded) return;

      emit(RegionsLoading());
      try {
        emit(RegionsLoaded(items: await useCase.call()));
      } catch (_) {
        emit(RegionsError());
      }
    });
  }
}
