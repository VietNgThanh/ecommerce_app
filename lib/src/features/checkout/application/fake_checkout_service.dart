import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/data/fake_auth_repository.dart';
import '../../cart/data/remote/remote_cart_repository.dart';
import '../../cart/domain/cart.dart';
import '../../orders/data/fake_orders_repository.dart';
import '../../orders/domain/order.dart';
import '../../products/data/fake_products_repository.dart';

class FakeCheckoutService {
  FakeCheckoutService(this.ref);
  final Ref ref;

  Future<void> placeOrder() async {
    final authRepository = ref.read(authRepositoryProvider);
    final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
    final ordersRepository = ref.read(ordersRepositoryProvider);
    final uid = authRepository.currentUser!.uid;
    // 1. Get the cart object
    final cart = await remoteCartRepository.fetchCart(uid);
    final total = _totalPrice(cart);
    final orderDate = DateTime.now();
    final orderId = orderDate.toIso8601String();
    // 2. Create an order
    final order = Order(
      id: orderId,
      userId: uid,
      items: cart.items,
      orderStatus: OrderStatus.confirmed,
      orderDate: orderDate,
      total: total,
    );
    // 3. Save it using the repository
    await ordersRepository.addOrder(uid, order);
    // 4. Empty the cart
    await remoteCartRepository.setCart(uid, const Cart());
  }

  double _totalPrice(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }
    final producsRepository = ref.read(productsRepositoryProvider);
    return cart.items.entries
        .map((entry) =>
            entry.value * // quantity
            producsRepository.getProduct(entry.key)!.price) // price
        .reduce((value, element) => value + element);
  }
}

final checkoutServiceProvider = Provider<FakeCheckoutService>((ref) {
  return FakeCheckoutService(ref);
});
