import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockLocalCartRepository localCartRepository;
  late MockRemoteCartRepository remoteCartRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    localCartRepository = MockLocalCartRepository();
    remoteCartRepository = MockRemoteCartRepository();
  });

  group('setItem', () {
    test('null user, writes item to local cart', () async {
      // setup
      const expectedCart = Cart({'abc': 1});
      when(
        () => authRepository.currentUser,
      ).thenReturn(null);
      when(
        localCartRepository.fetchCart,
      ).thenAnswer((_) => Future.value(const Cart()));
      when(
        () => localCartRepository.setCart(expectedCart),
      ).thenAnswer((_) => Future.value());

      final cartService = CartService(
        authRepository: authRepository,
        localCartRepository: localCartRepository,
        remoteCartRepository: remoteCartRepository,
      );

      // run
      await cartService.setItem(
        const Item(productId: 'abc', quantity: 1),
      );

      // verify
      verify(
        () => localCartRepository.setCart(expectedCart),
      ).called(1);
      verifyNever(
        () => remoteCartRepository.setCart(any(), any()),
      );
    });

    test('non-null user, writes item to remote cart', () async {
      // setup
      const expectedCart = Cart({'abc': 1});
      const testUser = AppUser(uid: 'testId');
      when(
        () => authRepository.currentUser,
      ).thenReturn(AppUser(uid: testUser.uid));
      when(
        () => remoteCartRepository.fetchCart(testUser.uid),
      ).thenAnswer((_) => Future.value(const Cart()));
      when(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).thenAnswer((_) => Future.value());

      final cartService = CartService(
        authRepository: authRepository,
        localCartRepository: localCartRepository,
        remoteCartRepository: remoteCartRepository,
      );

      // run
      await cartService.setItem(
        const Item(productId: 'abc', quantity: 1),
      );

      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(
        () => localCartRepository.setCart(any()),
      );
    });
  });
}
