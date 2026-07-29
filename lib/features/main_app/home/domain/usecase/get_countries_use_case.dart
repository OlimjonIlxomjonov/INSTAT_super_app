import 'package:my_template/features/main_app/home/domain/entity/country/country_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class GetCountriesUseCase {
  final HomeRepository repository;

  GetCountriesUseCase({required this.repository});

  Future<List<CountryEntity>> call() {
    return repository.getCountries();
  }
}
