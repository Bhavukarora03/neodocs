

import 'package:flutter/material.dart';

class GlobalSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    String actionLabel = 'DISMISS',
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.black,
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}