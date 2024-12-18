import 'package:flutter/material.dart';

class CustomSeparatedPartTitle extends StatelessWidget {
  const CustomSeparatedPartTitle(
      {super.key, required this.title, this.titleStyle});
  final String title;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: titleStyle ??
              Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
