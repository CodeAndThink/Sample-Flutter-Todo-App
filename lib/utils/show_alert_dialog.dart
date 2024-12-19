import 'package:flutter/material.dart';
import 'package:todo_app/common/views/alert.dart';

/// Displays an alert dialog with a title, content, and actions.
/// 
/// [context] - The build context to show the dialog.
/// [title] - The title of the alert dialog.
/// [content] - The content of the alert dialog.
/// [mainAction] - The main action to be executed when the main action button is pressed.
/// [mainActionLabel] - The label for the main action button.
/// [subAction] - An optional secondary action to be executed when the secondary action button is pressed.
/// [subActionLabel] - The label for the secondary action button, if any.
void showAlert(
    BuildContext context,
    String title,
    String content,
    VoidCallback mainAction,
    String mainActionLabel,
    VoidCallback? subAction,
    String? subActionLabel,) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Alert(
        title: title,
        content: content,
        mainAction: mainAction,
        mainActionLabel: mainActionLabel,
        subAction: subAction,
        subActionLabel: subActionLabel,
      );
    },
  );
}
