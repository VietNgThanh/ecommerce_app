import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController({
    required EmailPasswordSignInFormType formType,
    required FakeAuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(EmailPasswordSignInState(formType: formType));

  final FakeAuthRepository _authRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());
    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);
    return !value.hasError;
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(formType: formType);
  }

  Future<void> _authenticate(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return _authRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return _authRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final authRepository = ref.watch(authRepositoryProvider);
  return EmailPasswordSignInController(
    authRepository: authRepository,
    formType: formType,
  );
});
