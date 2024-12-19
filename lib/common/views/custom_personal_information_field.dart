import 'package:flutter/material.dart';

class CustomPersonalInformationField extends StatelessWidget {
  const CustomPersonalInformationField(
      {super.key,
      required this.title,
      this.titleStyle,
      required this.information,
      this.informationStyle});
  final String title;
  final TextStyle? titleStyle;
  final String information;
  final TextStyle? informationStyle;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Row(
      children: [
        SizedBox(
          width: screenHeight > screenWidth
              ? screenWidth * 0.3
              : screenHeight * 0.3,
          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: titleStyle ??
                  Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
            child: Text(
          information,
          style: informationStyle ?? Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
  }
}
