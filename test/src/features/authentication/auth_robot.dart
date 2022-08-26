// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/common_widgets/common_widgets.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  const AuthRobot({
    required this.tester,
  });
  final WidgetTester tester;

  Future<void> pumpEmailAndPasswordSignInContents({
    required FakeAuthRepository authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignIn,
  }) {
    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EmailPasswordSignInContents(
              formType: formType,
              onSignedIn: onSignIn,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tapChangeFormTypeButton() async {
    final finder = find.byType(CustomTextButton);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  Future<void> expectSignInForm() async {
    final finder = find.text('Sign in');
    expect(finder, findsOneWidget);
  }

  Future<void> expectRegisterForm() async {
    final finder = find.text('Create an account');
    expect(finder, findsOneWidget);
  }

  Future<void> tapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pump();
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(
    String password,
  ) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
  }

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (authRepository != null)
            authRepositoryProvider.overrideWithValue(
              authRepository,
            )
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
  }

  Future<void> tapLogoutButton() async {
    final finder = find.text('Logout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectErrorAlertDialogFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertDialogNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}
