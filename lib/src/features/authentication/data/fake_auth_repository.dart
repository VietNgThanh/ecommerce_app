import '../../../utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';
import '../../../utils/in_memory_store.dart';

// abstract class AuthRepository {
//   Stream<AppUser?> authStateChanges();
//   AppUser? get currentUser;
//   Future<void> signInWithEmailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
// }

class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);
  final bool addDelay;

  FakeAuthRepository({
    this.addDelay = true,
  });

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // return Future.delayed(
    //     const Duration(seconds: 1), () => throw Exception('Connection Failed'));
    await delay(addDelay);
    _createNewUser(email);
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // return Future.delayed(
    //     const Duration(seconds: 1), () => throw Exception('Connection Failed'));
    await delay(addDelay);
    _createNewUser(email);
  }

  Future<void> signOut() async {
    // return Future.delayed(
    //     const Duration(seconds: 1), () => throw Exception('Connection Failed'));
    await delay(addDelay);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesStreamProvider =
    StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
