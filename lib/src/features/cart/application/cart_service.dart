// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  const CartService({
    required this.authRepository,
    required this.localCartRepository,
    required this.remoteCartRepository,
  });

  final FakeAuthRepository authRepository;
  final LocalCartRepository localCartRepository;
  final RemoteCartRepository remoteCartRepository;

  /// fetch the cart from the local or remote repository depending on the user
  /// auth state
  Future<Cart> _fetchCart() {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteCartRepository.fetchCart(user.uid);
    }
    return localCartRepository.fetchCart();
  }

  /// save the cart to the local or remote repository depending on the user
  /// auth state
  Future<void> _setCart(Cart cart) {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteCartRepository.setCart(user.uid, cart);
    }
    return localCartRepository.setCart(cart);
  }

  /// sets an item in the local or remote cart depending on the user auth state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final update = cart.setItem(item);
    await _setCart(update);
  }

  /// adds an item in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final update = cart.addItem(item);
    await _setCart(update);
  }

  /// removes an item in the local or remote cart depending on the user auth
  /// state
  Future<void> removeItemById(ProductID productID) async {
    final cart = await _fetchCart();
    final update = cart.removeItemById(productID);
    await _setCart(update);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(
    authRepository: ref.watch(authRepositoryProvider),
    localCartRepository: ref.watch(localCartRepositoryProvider),
    remoteCartRepository: ref.watch(remoteCartRepositoryProvider),
  );
});

final cartProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesStreamProvider).value;
  if (user == null) {
    return ref.watch(localCartRepositoryProvider).watchCart();
  } else {
    return ref.watch(remoteCartRepositoryProvider).watchCart(user.uid);
  }
});

final cartItemsCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).maybeMap(
        data: (cart) => cart.value.items.length,
        orElse: () => 0,
      );
});

final cartTotalProvider = Provider.autoDispose<double>((ref) {
  final cart = ref.watch(cartProvider).value ?? const Cart();
  final productsList =
      ref.watch(productsListStreamProvider).value ?? const <Product>[];

  if (cart.items.isEmpty || productsList.isEmpty) {
    return 0.0;
  }

  var total = 0.0;
  cart.items.forEach((productId, quantity) {
    final product =
        productsList.firstWhere((product) => product.id == productId);
    total += product.price * quantity;
  });
  return total;
});

final itemAvailableQuantityProvider =
    Provider.autoDispose.family<int, Product>((ref, product) {
  final cart = ref.watch(cartProvider).value;

  if (cart == null) {
    return product.availableQuantity;
  }

  // get the current quantity for the given product in the cart
  final quantity = cart.items[product.id] ?? 0;
  // subtract it from the product available quantity
  return max(0, product.availableQuantity - quantity);
});
