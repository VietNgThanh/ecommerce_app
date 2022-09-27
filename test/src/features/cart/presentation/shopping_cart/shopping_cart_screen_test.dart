import 'package:flutter_test/flutter_test.dart';
import '../../../../robot.dart';

void main() {
  group('shopping cart', () {
    testWidgets('Empty shopping cart', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      r.productsRobot
          .expectFindNProductCards(14); // check all products are found
      await r.cartRobot.openCart();
      r.cartRobot.expectShoppingCartIsEmpty();
    });

    testWidgets('Add product with quantity = 1', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      r.cartRobot.expectItemQuantity(quantity: 1, atIndex: 0);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$15.00');
    });

    testWidgets('Add product with quantity = 5', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(5);
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      r.cartRobot.expectItemQuantity(quantity: 5, atIndex: 0);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$75.00');
    });

    testWidgets('Add product with quantity = 6', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(6);
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      r.cartRobot.expectItemQuantity(quantity: 5, atIndex: 0);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$75.00');
    });

    testWidgets('Add product with quantity = 2, then increment by 2',
        (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(2);
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      await r.cartRobot.incrementCartItemQuantity(quantity: 2, atIndex: 0);
      r.cartRobot.expectItemQuantity(quantity: 4, atIndex: 0);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$60.00');
    });

    testWidgets('Add product with quantity = 5, then decrement by 2',
        (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(5);
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      await r.cartRobot.decrementCartItemQuantity(quantity: 2, atIndex: 0);
      r.cartRobot.expectItemQuantity(quantity: 3, atIndex: 0);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$45.00');
    });

    testWidgets('Add two products', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      // add first product
      await r.productsRobot.selectProduct(atIndex: 0);
      await r.cartRobot.addToCart();
      await r.goBack();
      // add second product
      await r.productsRobot.selectProduct(atIndex: 1);
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      r.cartRobot.expectFindNCartItems(2);
      r.cartRobot.expectShoppingCartTotalIs('Total: \$28.00');
    });

    testWidgets('Add product, then delete it', (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.cartRobot.addToCart();
      await r.cartRobot.openCart();
      await r.cartRobot.deleteCartItem(atIndex: 0);
      r.cartRobot.expectShoppingCartIsEmpty();
    });

    testWidgets('Add product with quantity = 5, goes out of stock',
        (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(5);
      await r.cartRobot.addToCart();
      r.cartRobot.expectProductIsOutOfStock();
    });

    testWidgets(
        'Add product with quantity = 5, remains out of stock when opened again',
        (tester) async {
      final r = Robot(tester: tester);
      await r.pumpMyApp();
      await r.productsRobot.selectProduct();
      await r.productsRobot.setProductQuantity(5);
      await r.cartRobot.addToCart();
      await r.goBack();
      await r.productsRobot.selectProduct();
      r.cartRobot.expectProductIsOutOfStock();
    });
  });
}
