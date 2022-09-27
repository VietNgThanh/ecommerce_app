import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Full purchase flow', (tester) async {
    final r = Robot(tester: tester);
    await r.pumpMyApp();
    r.productsRobot.expectFindAllProductCards();
    // add to cart flows
    await r.productsRobot.selectProduct();
    await r.productsRobot.setProductQuantity(3);
    await r.cartRobot.addToCart();
    await r.cartRobot.openCart();
    r.cartRobot.expectFindNCartItems(1);
    await r.closePage();
    // sign in
    await r.openPopupMenu();
    await r.authRobot.openEmailPasswordSignInScreen();
    await r.authRobot.signInWithEmailAndPassword();
    r.productsRobot.expectFindAllProductCards();
    // check cart again (to verify cart synchronization)
    await r.cartRobot.openCart();
    r.cartRobot.expectFindNCartItems(1);
    await r.closePage();
    // sign out
    await r.openPopupMenu();
    await r.authRobot.openAccountScreen();
    await r.authRobot.tapLogoutButton();
    await r.authRobot.tapDialogLogoutButton();
    r.productsRobot.expectFindAllProductCards();
  });
}
