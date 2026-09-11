import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';
import 'package:my_template/features/main_app/home/domain/usecase/notifications/mark_notif_read_use_case.dart';
import 'package:my_template/features/main_app/home/domain/usecase/notifications/notif_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_state.dart';

class NotifBloc extends Bloc<HomeEvent, NotifState> {
  final NotifUseCase useCase;
  final MarkNotifReadUseCase markReadUseCase;
  final MarkAllNotifsReadUseCase markAllReadUseCase;

  NotifBloc({
    required this.useCase,
    required this.markReadUseCase,
    required this.markAllReadUseCase,
  }) : super(NotifInitial()) {
    on<NotifEvent>((event, emit) async {
      emit(NotifLoading());
      try {
        final response = await useCase.call(params: event.params);
        emit(NotifLoaded(response: response));
      } catch (e) {
        emit(NotifError());
      }
    });

    on<MarkNotifReadEvent>((event, emit) async {
      /// OPTIMISTIC
      final current = state;
      if (current is NotifLoaded) {
        emit(NotifLoaded(response: _withRead(current.response, {event.id})));
      }
      try {
        await markReadUseCase(event.id);
      } catch (e) {
        if (current is NotifLoaded) emit(current);
      }
    });

    on<MarkAllNotifsReadEvent>((event, emit) async {
      final current = state;
      if (current is NotifLoaded) {
        final ids = current.response.data.map((e) => e.id).toSet();
        emit(NotifLoaded(response: _withRead(current.response, ids)));
      }
      try {
        await markAllReadUseCase();
      } catch (e) {
        if (current is NotifLoaded) emit(current);
      }
    });
  }

  NotifResponse _withRead(NotifResponse response, Set<int> ids) {
    return NotifResponse(
      links: response.links,
      meta: response.meta,
      data: response.data
          .map(
            (item) => ids.contains(item.id) && !item.isRead
                ? NotifEntity(
                    id: item.id,
                    title: item.title,
                    link: item.link,
                    message: item.message,
                    isRead: true,
                    createdAt: item.createdAt,
                  )
                : item,
          )
          .toList(),
    );
  }
}
