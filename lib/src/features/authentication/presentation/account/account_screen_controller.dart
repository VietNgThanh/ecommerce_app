import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required FakeAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AsyncValue.data(null));

  final FakeAuthRepository _authRepository;
  Future<void> signOut() async {
    // try {
    //   // set state to loading
    //   state = const AsyncValue.loading();
    //   // sign out (using auth repository)
    //   await _authRepository.signOut();
    //   // if success, set state to data and return true
    //   state = const AsyncValue.data(null);
    //   return true;
    // } catch (e) {
    //   // if error, set state to error and return false
    //   state = AsyncValue.error(e);
    //   return false;
    // }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authRepository,
  );
});
