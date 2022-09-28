import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/data/fake_auth_repository.dart';
import '../data/fake_orders_repository.dart';
import '../domain/order.dart';

/// NOTE: Only watch this provider if the user is signed in.
final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesStreamProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // If the user is null, just return an empty stream.
    return const Stream.empty();
  }
});
