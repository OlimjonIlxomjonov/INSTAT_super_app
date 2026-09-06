import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/entity/site_faqs/site_faqs_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class SiteFaqsUseCase {
  final HomeRepository repository;

  SiteFaqsUseCase({required this.repository});

  Future<List<SiteFaqsEntity>> call({required SiteFaqsParams params}) {
    return repository.getSiteFaqs(params: params);
  }
}
