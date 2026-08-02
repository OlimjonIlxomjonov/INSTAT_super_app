import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class DataRequestsUseCase {
  final MicroRepository repository;

  DataRequestsUseCase({required this.repository});

  Future<DataRequestsResponse> call({
    required String status,
    required String search,
    int page = 1,
  }) {
    return repository.getDataRequests(
      status: status,
      search: search,
      page: page,
    );
  }
}
