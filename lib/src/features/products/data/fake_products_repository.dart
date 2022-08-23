import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/test_products.dart';
import '../domain/product.dart';
import '../../../utils/delay.dart';

class FakeProductsRepository {
  const FakeProductsRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProduct(_products, id);
  }

  Future<List<Product>> fetchProductsList() {
    // await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Connection Failed');
    delay(addDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() {
    delay(addDelay);
    return Stream.value(_products);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map((products) => _getProduct(products, id));
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere(
        (product) => product.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return const FakeProductsRepository();
});

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.watchProductsList();
  },
  // disposeDelay: const Duration(seconds: 10),
  // cacheTime: const Duration(seconds: 10),
);

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>(
  (ref) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.fetchProductsList();
  },
  // disposeDelay: const Duration(seconds: 10),
  // cacheTime: const Duration(seconds: 10),
);

final productStreamProvider =
    StreamProvider.autoDispose.family<Product?, String>(
  (ref, id) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.watchProduct(id);
  },
  disposeDelay: const Duration(seconds: 5),
  cacheTime: const Duration(seconds: 60),
);
