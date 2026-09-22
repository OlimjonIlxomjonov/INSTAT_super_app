import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/services/banners/banner_source_prefs_service.dart';

class BannerSourceCubit extends Cubit<bool> {
  BannerSourceCubit() : super(BannerSourcePrefsService.loadUseRemote());

  void setUseRemote(bool value) {
    if (value == state) return;
    emit(value);
    BannerSourcePrefsService.save(value);
  }
}
