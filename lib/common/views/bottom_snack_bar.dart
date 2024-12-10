import 'package:flutter/material.dart';

void bottomNotification(BuildContext context, Widget child) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: child,
    ),
  );
}
