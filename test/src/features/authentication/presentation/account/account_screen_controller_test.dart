import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  final exception = Exception('Connection Failed');

  setUp(
    () {
      authRepository = MockAuthRepository();
      controller = AccountScreenController(authRepository: authRepository);
    },
  );
  group(
    'AccountScreenController',
    () {
      test(
        'initial state is AsyncValue.data',
        () {
          expect(
            controller.debugState,
            const AsyncData<void>(null),
          );
        },
      );

      test(
        'signOut success',
        () async {
          when(authRepository.signOut).thenAnswer(
            (_) => Future.value(),
          );

          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ]),
          );

          await controller.signOut();

          verify(authRepository.signOut).called(1);
        },
      );

      test(
        'signOut failure',
        () async {
          when(authRepository.signOut).thenThrow(exception);

          expectLater(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.error, exception);
                return true;
              }),
            ]),
          );

          await controller.signOut();

          verify(authRepository.signOut).called(1);
        },
      );
    },
  );
}
