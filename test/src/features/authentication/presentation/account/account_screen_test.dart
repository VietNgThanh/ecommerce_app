import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester: tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

  testWidgets('Confirm logout, success', (tester) async {
    final r = AuthRobot(tester: tester);
    await r.pumpAccountScreen();
    await tester.runAsync(() async {
      await r.tapLogoutButton();
    });
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectErrorAlertDialogNotFound();
  });

  testWidgets('Confirm logout, failure', (tester) async {
    final r = AuthRobot(tester: tester);
    final authRepository = MockAuthRepository();
    final exception = Exception('Connection failed');
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(
          uid: '123',
          email: 'test@test.com',
        ),
      ),
    );

    when(authRepository.signOut).thenThrow(exception);
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogoutButton();
    r.expectLogoutDialogFound();
    await r.tapDialogLogoutButton();
    r.expectErrorAlertDialogFound();
  });

  testWidgets('Confirm logout, loading state', (tester) async {
    final r = AuthRobot(tester: tester);
    final authRepository = MockAuthRepository();
    when(authRepository.authStateChanges).thenAnswer(
      (_) => Stream.value(
        const AppUser(
          uid: '123',
          email: 'test@test.com',
        ),
      ),
    );

    when(authRepository.signOut).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
      ),
    );
    await r.pumpAccountScreen(authRepository: authRepository);
    await tester.runAsync(() async {
      await r.tapLogoutButton();
      r.expectLogoutDialogFound();
      await r.tapDialogLogoutButton();
    });
    r.expectCircularProgressIndicator();
  });
}
