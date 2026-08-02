import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';

class DataRequestProcessesState extends Equatable {
  const DataRequestProcessesState();

  @override
  List<Object?> get props => [];
}

class DataRequestProcessesInitial extends DataRequestProcessesState {}

class DataRequestProcessesLoading extends DataRequestProcessesState {}

class DataRequestProcessesLoaded extends DataRequestProcessesState {
  final List<DataRequestProcessEntity> items;

  const DataRequestProcessesLoaded({required this.items});

  /// Ekspert javobi — fayl biriktirilgan jarayonlar.
  List<DataRequestProcessEntity> get withFiles =>
      items.where((item) => item.hasFile).toList();

  @override
  List<Object?> get props => [items];
}

class DataRequestProcessesError extends DataRequestProcessesState {}

class DataRequestProcessesBloc
    extends Bloc<MicroDataEvent, DataRequestProcessesState> {
  final DataRequestProcessesUseCase useCase;

  DataRequestProcessesBloc({required this.useCase})
    : super(DataRequestProcessesInitial()) {
    on<DataRequestProcessesEvent>((event, emit) async {
      emit(DataRequestProcessesLoading());
      try {
        emit(DataRequestProcessesLoaded(items: await useCase(event.requestId)));
      } catch (_) {
        emit(DataRequestProcessesError());
      }
    });
  }
}
