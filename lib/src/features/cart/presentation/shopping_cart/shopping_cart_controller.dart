// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';

import '../../../products/domain/product.dart';
import '../../domain/item.dart';

class ShoppingCartController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartController({required this.cartService})
      : super(const AsyncData(null));
  final CartService cartService;

  Future<void> updateItemQuantity(ProductID productID, int quantity) async {
    state = const AsyncLoading();
    final update = Item(productId: productID, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(update));
  }

  Future<void> removeItemById(ProductID productID) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => cartService.removeItemById(productID));
  }
}

final shoppingCartcontrollerProvider =
    StateNotifierProvider.autoDispose<ShoppingCartController, AsyncValue<void>>(
        (ref) {
  return ShoppingCartController(
    cartService: ref.watch(cartServiceProvider),
  );
});
