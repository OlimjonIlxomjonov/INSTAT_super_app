import 'package:my_template/features/mikro_data/data/source/remote_data_source/micro_remote_data_source.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_requests_response.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';
import 'package:my_template/features/mikro_data/domain/repository/micro_repository.dart';

class MicroRepoImpl implements MicroRepository {
  final MicroRemoteDataSource _remoteDataSource;

  MicroRepoImpl({required MicroRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ReportsResponse> getReportsCard() {
    return _remoteDataSource.fetchReportsCard();
  }

  @override
  Future<DataRequestsResponse> getDataRequests({
    required String status,
    required String search,
    int page = 1,
  }) {
    return _remoteDataSource.fetchDataRequests(
      status: status,
      search: search,
      page: page,
    );
  }
}
