import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key, required this.iconPath, required this.action});
  final String iconPath;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: action,
        icon: Image.asset(
          iconPath,
          height: 30,
          width: 30,
        ));
  }
}
