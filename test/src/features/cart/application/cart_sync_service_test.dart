import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;
  late MockProductsRepository productsRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
    productsRepository = MockProductsRepository();
  });

  CartSyncService makeCartSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      localCartRepositoryProvider.overrideWithValue(localCartRepository),
      productsRepositoryProvider.overrideWithValue(productsRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(cartSyncServiceProvider);
  }

  group('CartSyncService', () {
    Future<void> runCartSyncService({
      required Map<ProductID, int> localCartItems,
      required Map<ProductID, int> remoteCartItems,
      required Map<ProductID, int> expectedRemoteCartItems,
    }) async {
      // set up
      const uid = 'test';
      const email = 'test@test.com';
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(const AppUser(
          uid: uid,
          email: email,
        )),
      );
      when(productsRepository.fetchProductsList).thenAnswer(
        (_) => Future.value(kTestProducts),
      );
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(Cart(localCartItems)),
      );
      when(() => remoteCartRepository.fetchCart(uid)).thenAnswer(
        (_) => Future.value(Cart(remoteCartItems)),
      );

      when(() => localCartRepository.setCart(const Cart())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => remoteCartRepository.setCart(
            uid,
            Cart(expectedRemoteCartItems),
          )).thenAnswer(
        (_) => Future.value(),
      );

      // create CartSyncService
      makeCartSyncService();

      // wait for all stubbed methods to return a value
      await Future.delayed(const Duration());

      // verify
      verify(
        () => remoteCartRepository.setCart(
          uid,
          Cart(expectedRemoteCartItems),
        ),
      ).called(1);

      verify(
        () => localCartRepository.setCart(
          const Cart(),
        ),
      ).called(1);

      await localCartRepository.fetchCart();
      await remoteCartRepository.fetchCart(uid);
      authRepository.authStateChanges();
    }

    test('local quantity <= available quantity', () async {
      await runCartSyncService(
        localCartItems: {'1': 1},
        remoteCartItems: {},
        expectedRemoteCartItems: {'1': 1},
      );
    });

    test('local quantity > available quantity', () async {
      await runCartSyncService(
        localCartItems: {'1': 15},
        remoteCartItems: {},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    test('local quantity + remote quantity <= available quantity', () async {
      await runCartSyncService(
        localCartItems: {'1': 2},
        remoteCartItems: {'1': 3},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    test('local quantity + remote quantity > available quantity', () async {
      await runCartSyncService(
        localCartItems: {'1': 3},
        remoteCartItems: {'1': 3},
        expectedRemoteCartItems: {'1': 5},
      );
    });

    test('multiple items', () async {
      await runCartSyncService(
        localCartItems: {'1': 3, '2': 4, '3': 6},
        remoteCartItems: {'1': 3},
        expectedRemoteCartItems: {'1': 5, '2': 4, '3': 5},
      );
    });
  });
}
