import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/features/main_app/home/domain/usecase/banner/get_active_banners_use_case.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_state.dart';

class BannerBloc extends Bloc<FetchBannersEvent, BannerState> {
  final GetActiveBannersUseCase useCase;

  BannerBloc(this.useCase) : super(BannerInitial()) {
    on<FetchBannersEvent>((event, emit) async {
      emit(BannerLoading());
      try {
        final banners = await useCase.call();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerError());
      }
    });
  }
}
