import 'dart:async';

import 'src/features/cart/application/cart_sync_service.dart';
import 'src/features/cart/data/local/sembast_cart_repository.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/app.dart';
import 'src/features/cart/data/local/local_cart_repository.dart';
import 'src/localization/string_hardcoded.dart';

void main() async {
  // * For more info on error handling, see:
  // * https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // * Turn off the # in the URLs on the web
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

    // * Local cart repository
    final localCartRepository = await SembastCartRepository.makeDefault();
    // * Create ProviderContainer with any required overrides
    final container = ProviderContainer(overrides: [
      localCartRepositoryProvider.overrideWithProvider(
        Provider<LocalCartRepository>((ref) {
          ref.onDispose(localCartRepository.dispose);
          return localCartRepository;
        }),
      ),
    ]);
    // * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);
    // * Entry point of the app
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    // * This code will present some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    // * Log any errors to console
    debugPrint(error.toString());
  });
}
