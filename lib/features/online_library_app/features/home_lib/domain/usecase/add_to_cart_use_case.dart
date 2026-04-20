import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class AddToCartUseCase {
  final HomeLibRepository repository;

  AddToCartUseCase({required this.repository});

  Future<void> call(int id) {
    return repository.addToCart(id);
  }
}
