import 'package:flutter/material.dart';

import '../../../../common_widgets/common_widgets.dart';
import '../../../../localization/string_hardcoded.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends StatelessWidget {
  const PaymentButton({Key? key}) : super(key: key);

  Future<void> _pay(BuildContext context) async {
    // TODO: Implement
    showNotImplementedAlertDialog(context: context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: error handling
    // TODO: loading state
    return PrimaryButton(
      text: 'Pay'.hardcoded,
      isLoading: false,
      onPressed: () => _pay(context),
    );
  }
}
