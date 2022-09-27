import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345678';
  final exception = Exception('Connection Failed');
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('sign in', () {
    testWidgets('''
      Given formType signIn
      When tap on sign-in button
      Then signInWithEmailAndPassword is not called
      ''', (tester) async {
      final r = AuthRobot(tester: tester);
      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );
      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.signInWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    testWidgets('''
      Given formType signIn
      When enter email and password
      And tap on sign-in button
      Then signInWithEmailAndPassword is called
      And onSignIn callback is called
      And error alert is not shown
      ''', (tester) async {
      final r = AuthRobot(tester: tester);
      var didSignIn = false;
      when(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
      ).thenAnswer((_) => Future.value());

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSignIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
      ).called(1);
      r.expectErrorAlertDialogNotFound();
      expect(didSignIn, true);
    });

    testWidgets('''
      Given formType signIn
      When enter email and password
      And tap on sign-in button
      Then signInWithEmailAndPassword is called
      And error alert is shown
      And onSignIn callback is not called
      ''', (tester) async {
      final r = AuthRobot(tester: tester);
      var didSignIn = false;
      when(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
      ).thenThrow(exception);

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
        onSignIn: () => didSignIn = true,
      );
      await r.enterEmail(testEmail);
      await r.enterPassword(testPassword);
      await r.tapEmailAndPasswordSubmitButton();
      verify(
        () => authRepository.signInWithEmailAndPassword(
          testEmail,
          testPassword,
        ),
      ).called(1);
      r.expectErrorAlertDialogFound();
      expect(didSignIn, false);
    });
  });

  group('updateFormType', () {
    testWidgets('''
      Given form type sign in
      When tap on change form type
      Then form type is register
      Then tap again and form type is sign in
      ''', (tester) async {
      final r = AuthRobot(tester: tester);

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      r.expectSignInForm();
      await r.tapChangeFormTypeButton();
      r.expectRegisterForm();
      await r.tapChangeFormTypeButton();
      r.expectSignInForm();
    });
  });

  group('client-side validation for email and password', () {
    testWidgets('''
      Given form type register
      When tap on create an account button
      Then createUserWithEmailAndPassword is not called
      ''', (tester) async {
      final r = AuthRobot(tester: tester);

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    testWidgets('''
      Given form type register
      Enter valid email
      Enter invalid password
      When tap on create an account button
      Then createUserWithEmailAndPassword is not called
      ''', (tester) async {
      final r = AuthRobot(tester: tester);

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      await r.enterEmail(testEmail);
      await r.enterPassword('');

      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });

    testWidgets('''
      Given form type register
      Enter invalid email
      Enter valid password
      When tap on create an account button
      Then createUserWithEmailAndPassword is not called
      ''', (tester) async {
      final r = AuthRobot(tester: tester);

      await r.pumpEmailAndPasswordSignInContents(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      await r.enterEmail('invalid');
      await r.enterPassword(testPassword);

      await r.tapEmailAndPasswordSubmitButton();
      verifyNever(
        () => authRepository.createUserWithEmailAndPassword(
          any(),
          any(),
        ),
      );
    });
  });
}
