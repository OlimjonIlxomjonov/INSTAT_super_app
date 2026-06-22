import 'package:my_template/features/mikro_data/data/source/remote_data_source/micro_remote_data_source.dart';
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
}
