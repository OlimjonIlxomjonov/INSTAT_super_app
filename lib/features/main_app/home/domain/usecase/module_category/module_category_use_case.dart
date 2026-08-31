import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_response.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class ModuleCategoryUseCase {
  final HomeRepository repository;

  ModuleCategoryUseCase({required this.repository});

  Future<ModuleCategoryResponse> call({required ModuleCategoryParams params}) {
    return repository.getModuleCategory(params: params);
  }
}
