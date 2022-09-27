import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Sign in and sign out flow', (tester) async {
    final r = Robot(tester: tester);
    await r.pumpMyApp();
    r.productsRobot.expectFindAllProductCards();
    await r.openPopupMenu();
    await r.authRobot.openEmailAndPasswordSignInScreen();
    await r.authRobot.signInWithEmailAndPassword();
    r.productsRobot.expectFindAllProductCards();
    await r.openPopupMenu();
    await r.authRobot.openAccountScreen();
    await r.authRobot.tapLogoutButton();
    await r.authRobot.tapDialogLogoutButton();
    r.productsRobot.expectFindAllProductCards();
  });
}
