import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DateTimeTextBox extends StatelessWidget {
  const DateTimeTextBox(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.iconPath,
      this.errorText,
      required this.action});
  final TextEditingController controller;
  final String hintText;
  final String iconPath;
  final String? errorText;
  final Future<void> Function(BuildContext context) action;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: const Color(0xFF1B1B1D)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(iconPath),
                  onPressed: () async {
                    action(context);
                  },
                ),
                errorText: errorText),
          );
        });
  }
}
