import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.lineNumber,
    this.isSecure,
    this.textError,
    required this.onTap,
  });
  final TextEditingController controller;
  final String hintText;
  final int lineNumber;
  final bool? isSecure;
  final String? textError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            onTap: onTap,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: lineNumber,
            obscureText: isSecure == null ? false : isSecure!,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 2.0,
                  ),
                ),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.clear(),
                      )
                    : null,
                errorText: textError),
          );
        });
  }
}
