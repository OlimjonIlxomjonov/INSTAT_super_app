import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class FaceRecUseCase {
  final HomeRepository repository;

  FaceRecUseCase({required this.repository});

  Future<void> call({required FaceRecParams params}) {
    return repository.faceRecognition(params: params);
  }
}
