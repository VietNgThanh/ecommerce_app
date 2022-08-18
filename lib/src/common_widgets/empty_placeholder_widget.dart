import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_sizes.dart';
import '../localization/string_hardcoded.dart';
import '../routing/app_router.dart';
import 'primary_button.dart';

/// Placeholder widget showing a message and CTA to go back to the home screen.
class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({Key? key, required this.message})
      : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            gapH32,
            PrimaryButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              text: 'Go Home'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}
