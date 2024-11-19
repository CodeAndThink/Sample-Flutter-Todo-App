import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatefulWidget {
  const CircleButton(
      {super.key,
      required this.onTap,
      required this.backgroundColor,
      required this.iconPath, required this.isSetAlpha});
  final VoidCallback onTap;
  final Color backgroundColor;
  final String iconPath;
  final bool isSetAlpha;

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: widget.backgroundColor.withAlpha(widget.isSetAlpha ? 50 : 255),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: Center(
            child: SvgPicture.asset(
          widget.iconPath,
          height: 24,
          width: 24,
        )),
      ),
    );
  }
}
