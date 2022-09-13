import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_controller.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common_widgets/common_widgets.dart';
import '../../../../localization/string_hardcoded.dart';
import '../../../../routing/app_router.dart';
import 'shopping_cart_item.dart';
import 'shopping_cart_items_builder.dart';

/// Shopping cart screen showing the items in the cart (with editable
/// quantities) and a button to checkout.
class ShoppingCartScreen extends ConsumerWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      shoppingCartcontrollerProvider,
      (_, state) => state.showAlerDialogOnError(context),
    );
    final state = ref.watch(shoppingCartcontrollerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'.hardcoded),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final cartValue = ref.watch(cartProvider);
          return AsyncValueWidget<Cart>(
            value: cartValue,
            data: (cart) => ShoppingCartItemsBuilder(
              items: cart.toItemsList(),
              itemBuilder: (_, item, index) => ShoppingCartItem(
                item: item,
                itemIndex: index,
              ),
              ctaBuilder: (_) => PrimaryButton(
                text: 'Checkout'.hardcoded,
                isLoading: state.isLoading,
                onPressed: () => context.pushNamed(AppRoute.checkout.name),
              ),
            ),
          );
        },
      ),
    );
  }
}
