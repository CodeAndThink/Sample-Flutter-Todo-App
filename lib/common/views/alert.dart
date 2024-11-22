import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Alert extends StatelessWidget {
  const Alert(
      {super.key,
      required this.title,
      required this.content,
      required this.action});
  final String title;
  final String content;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: action,
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ),
      ],
    );
  }
}
