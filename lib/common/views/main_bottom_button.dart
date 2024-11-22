import 'package:flutter/material.dart';

class MainBottomButton extends StatelessWidget {
  const MainBottomButton(
      {super.key, required this.ontap, required this.buttonLabel});
  final VoidCallback ontap;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          )),
          backgroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
      child: Text(
        buttonLabel,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
