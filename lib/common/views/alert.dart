import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert(
      {super.key,
      required this.title,
      required this.content,
      required this.mainAction,
      this.subAction,
      required this.mainActionLabel,
      this.subActionLabel});
  final String title;
  final String content;
  final String mainActionLabel;
  final VoidCallback mainAction;
  final String? subActionLabel;
  final VoidCallback? subAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: mainAction,
              child: Text(
                mainActionLabel,
              ),
            ),
            if (subAction != null && subActionLabel != null) ...[
              ElevatedButton(
                onPressed: subAction,
                child: Text(
                  subActionLabel!,
                ),
              ),
            ]
          ],
        )
      ],
    );
  }
}
