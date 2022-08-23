import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345678';
  final exception = Exception('Connection failed');
  late MockAuthRepository authRepository;
  late EmailPasswordSignInController controller;

  setUp(
    () {
      authRepository = MockAuthRepository();
    },
  );
  group(
    'EmailPasswordSignInController',
    () {
      group(
        'submit',
        () {
          test(
            '''
            Given formType is signIn
            when signInWithEmailAndPassword succeeds
            Then return true
            And state is AsyncData
            ''',
            () async {
              when(
                () => authRepository.signInWithEmailAndPassword(
                  testEmail,
                  testPassword,
                ),
              ).thenAnswer(
                (_) => Future.value(),
              );
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.signIn,
                authRepository: authRepository,
              );

              expectLater(
                controller.stream,
                emitsInOrder(
                  [
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.signIn,
                      value: const AsyncLoading<void>(),
                    ),
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.signIn,
                      value: const AsyncData<void>(null),
                    ),
                  ],
                ),
              );

              final result = await controller.submit(testEmail, testPassword);

              expect(result, true);
            },
          );

          test(
            '''
            Given formType is signIn
            when signInWithEmailAndPassword fails
            Then return false
            And state is AsyncError
            ''',
            () async {
              when(
                () => authRepository.signInWithEmailAndPassword(
                  testEmail,
                  testPassword,
                ),
              ).thenThrow(
                exception,
              );
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.signIn,
                authRepository: authRepository,
              );

              expectLater(
                controller.stream,
                emitsInOrder(
                  [
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.signIn,
                      value: const AsyncLoading<void>(),
                    ),
                    predicate<EmailPasswordSignInState>((value) {
                      expect(
                        value.formType,
                        EmailPasswordSignInFormType.signIn,
                      );
                      expect(
                        value.value.error,
                        exception,
                      );
                      return true;
                    }),
                  ],
                ),
              );

              final result = await controller.submit(testEmail, testPassword);

              expect(result, false);
            },
          );

          test(
            '''
            Given formType is register
            when createUserWithEmailAndPassword succeeds
            Then return true
            And state is AsyncData
            ''',
            () async {
              when(
                () => authRepository.createUserWithEmailAndPassword(
                  testEmail,
                  testPassword,
                ),
              ).thenAnswer(
                (_) => Future.value(),
              );
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.register,
                authRepository: authRepository,
              );

              expectLater(
                controller.stream,
                emitsInOrder(
                  [
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.register,
                      value: const AsyncLoading<void>(),
                    ),
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.register,
                      value: const AsyncData<void>(null),
                    ),
                  ],
                ),
              );

              final result = await controller.submit(testEmail, testPassword);

              expect(result, true);
            },
          );

          test(
            '''
            Given formType is register
            when createUserWithEmailAndPassword fails
            Then return false
            And state is AsyncError
            ''',
            () async {
              when(
                () => authRepository.createUserWithEmailAndPassword(
                  testEmail,
                  testPassword,
                ),
              ).thenThrow(
                exception,
              );
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.register,
                authRepository: authRepository,
              );

              expectLater(
                controller.stream,
                emitsInOrder(
                  [
                    EmailPasswordSignInState(
                      formType: EmailPasswordSignInFormType.register,
                      value: const AsyncLoading<void>(),
                    ),
                    predicate<EmailPasswordSignInState>((value) {
                      expect(
                        value.formType,
                        EmailPasswordSignInFormType.register,
                      );
                      expect(
                        value.value.error,
                        exception,
                      );
                      return true;
                    }),
                  ],
                ),
              );

              final result = await controller.submit(testEmail, testPassword);

              expect(result, false);
            },
          );
        },
      );
      group(
        'updateFormType',
        () {
          test(
            '''
            Given formType is signIn
            When called with register
            Then state.formType is register
            ''',
            () {
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.signIn,
                authRepository: authRepository,
              );

              expect(
                controller.debugState.formType,
                EmailPasswordSignInFormType.signIn,
              );

              controller.updateFormType(EmailPasswordSignInFormType.register);

              expect(
                controller.debugState.formType,
                EmailPasswordSignInFormType.register,
              );
            },
          );

          test(
            '''
            Given formType is register
            When called with signIn
            Then state.formType is signIn
            ''',
            () {
              controller = EmailPasswordSignInController(
                formType: EmailPasswordSignInFormType.register,
                authRepository: authRepository,
              );

              expect(
                controller.debugState.formType,
                EmailPasswordSignInFormType.register,
              );

              controller.updateFormType(EmailPasswordSignInFormType.signIn);

              expect(
                controller.debugState.formType,
                EmailPasswordSignInFormType.signIn,
              );
            },
          );
        },
      );
    },
  );
}
