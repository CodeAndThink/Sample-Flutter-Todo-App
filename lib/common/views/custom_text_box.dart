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
    required this.textChangeAction,
    required this.cleanAction,
  });
  final TextEditingController controller;
  final String hintText;
  final int lineNumber;
  final bool? isSecure;
  final String? textError;
  final VoidCallback onTap;
  final Function(String) textChangeAction;
  final Function() cleanAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      textInputAction: TextInputAction.done,
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: lineNumber,
      obscureText: isSecure == null ? false : isSecure!,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
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
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => cleanAction(),
                )
              : null,
          errorText: textError),
      onChanged: textChangeAction,
    );
  }
}
