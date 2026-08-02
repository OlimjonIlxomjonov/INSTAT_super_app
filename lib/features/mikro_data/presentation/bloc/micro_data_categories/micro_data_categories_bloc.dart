import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class MicroDataCategoriesState extends Equatable {
  const MicroDataCategoriesState();

  @override
  List<Object?> get props => [];
}

class MicroDataCategoriesInitial extends MicroDataCategoriesState {}

class MicroDataCategoriesLoading extends MicroDataCategoriesState {}

class MicroDataCategoriesLoaded extends MicroDataCategoriesState {
  final List<DataRequestCategoryEntity> items;

  const MicroDataCategoriesLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class MicroDataCategoriesError extends MicroDataCategoriesState {}

class MicroDataCategoriesBloc
    extends Bloc<MicroDataEvent, MicroDataCategoriesState> {
  final MicroDataCategoriesUseCase useCase;

  MicroDataCategoriesBloc({required this.useCase})
    : super(MicroDataCategoriesInitial()) {
    on<MicroDataCategoriesEvent>((event, emit) async {
      // Kategoriyalar o'zgarmas ma'lumot — bir marta yuklangach qayta
      // so'ramaymiz. Xato holatida qayta urinish mumkin bo'lib qoladi.
      if (state is MicroDataCategoriesLoaded) return;

      emit(MicroDataCategoriesLoading());
      try {
        emit(MicroDataCategoriesLoaded(items: await useCase.call()));
      } catch (_) {
        emit(MicroDataCategoriesError());
      }
    });
  }
}
