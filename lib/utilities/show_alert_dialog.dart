import 'package:flutter/material.dart';
import 'package:todo_app/common/views/alert.dart';

void showAlert(
    BuildContext context,
    String title,
    String content,
    Function() mainAction,
    String mainActionLabel,
    Function()? subAction,
    String? subActionLabel) {
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
