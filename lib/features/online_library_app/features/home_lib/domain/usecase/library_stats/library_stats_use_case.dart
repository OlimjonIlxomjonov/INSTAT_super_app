import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/library_stats/library_stats_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class LibraryStatsUseCase {
  final HomeLibRepository repository;

  LibraryStatsUseCase({required this.repository});

  Future<LibraryStatsEntity> call() {
    return repository.getLibraryStats();
  }
}
