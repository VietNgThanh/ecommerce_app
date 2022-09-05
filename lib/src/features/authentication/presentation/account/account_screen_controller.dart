import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/fake_auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  AccountScreenController({required FakeAuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AsyncData(null));

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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authRepository,
  );
});
