import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthTextBox extends StatefulWidget {
  const AuthTextBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.lineNumber,
    this.textError,
    required this.onTap,
    required this.textChangeAction,
  });

  final TextEditingController controller;
  final String hintText;
  final int lineNumber;
  final String? textError;
  final VoidCallback onTap;
  final Function(String) textChangeAction;

  @override
  State<AuthTextBox> createState() => _AuthTextBoxState();
}

class _AuthTextBoxState extends State<AuthTextBox> {
  bool isHided = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, value, child) {
          return TextField(
            onTap: widget.onTap,
            textInputAction: TextInputAction.done,
            controller: widget.controller,
            keyboardType: TextInputType.multiline,
            maxLines: widget.lineNumber,
            obscureText: isHided,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
                hintText: widget.hintText,
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
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: isHided
                            ? SvgPicture.asset("assets/icons/hide.svg",
                                height: 24, width: 24, fit: BoxFit.cover)
                            : SvgPicture.asset("assets/icons/view.svg",
                                height: 24, width: 24, fit: BoxFit.cover),
                        onPressed: () => setState(() {
                          isHided = !isHided;
                        }),
                      )
                    : null,
                errorText: widget.textError),
            onChanged: widget.textChangeAction,
          );
        });
  }
}
