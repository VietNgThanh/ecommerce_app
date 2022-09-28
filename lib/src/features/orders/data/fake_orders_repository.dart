import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/delay.dart';
import '../../../utils/in_memory_store.dart';
import '../domain/order.dart';

class FakeOrdersRepository {
  FakeOrdersRepository({this.addDelay = true});
  final bool addDelay;

  /// key: user ID
  /// value: list of orders for that user
  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  Stream<List<Order>> watchUserOrders(String uid) {
    return _orders.stream.map((ordersData) {
      final ordersList = ordersData[uid] ?? [];
      ordersList.sort(
        (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
      );
      return ordersList;
    });
  }

  Future<void> addOrder(String uid, Order order) async {
    await delay(addDelay);
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    userOrders.add(order);
    value[uid] = userOrders;
    _orders.value = value;
  }
}

final ordersRepositoryProvider = Provider<FakeOrdersRepository>((ref) {
  return FakeOrdersRepository();
});
