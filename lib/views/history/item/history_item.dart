import 'package:flutter/material.dart';
import 'package:todo_app/gen/assets.gen.dart';
import 'package:todo_app/models/note_model.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.note});
  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return SizedBox  (
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Text(note.taskTitle),
            const Spacer(),
            SizedBox(
              height: 24,
              width: 24,
              child: Image.asset(
                note.status
                    ? Assets.icons.done.path
                    : Assets.icons.notdone.path,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
