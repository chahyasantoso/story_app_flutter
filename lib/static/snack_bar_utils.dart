import 'package:flutter/material.dart';

mixin SnackBarUtils {
  void showSnackBar(BuildContext context, String? message) {
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
