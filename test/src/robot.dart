// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';

class Robot {
  final WidgetTester tester;
  final AuthRobot authRobot;

  Robot({
    required this.tester,
  }) : authRobot = AuthRobot(tester: tester);

  Future<void> pumpMyapp() async {
    const productRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsRepositoryProvider.overrideWithValue(productRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
  }

  void expectFindAllProductCards() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matchers = finder.evaluate();
    // if an item is found, it means the we're running
    // on an small window and can tap to reveal the menu
    if (matchers.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  Future<void> tapSignInButton() async {
    final finder = find.text('Sign in');
  }
}
